local curl = require("plenary.curl")
local Path = require("plenary.path")

local M = {
	schemas_catalog = "datreeio/CRDs-catalog",
	schema_catalog_branch = "main",
	github_base_api_url = "https://api.github.com/repos",
	github_headers = {
		Accept = "application/vnd.github+json",
		["X-GitHub-Api-Version"] = "2022-11-28",
	},
	k8s_schemas_url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master",
	schemastore_api_url = "https://www.schemastore.org/api/json/catalog.json",
	cache_dir = vim.fn.stdpath("cache") .. "/schemas",
	cache_ttl = 86400,
}

M.schema_url = "https://raw.githubusercontent.com/" .. M.schemas_catalog .. "/" .. M.schema_catalog_branch

M.ensure_cache_dir = function()
	local cache_path = Path:new(M.cache_dir)
	if not cache_path:exists() then
		cache_path:mkdir({ parents = true })
	end
end

M.is_cache_valid = function(cache_file, ttl)
	ttl = ttl or M.cache_ttl
	local cache_path = Path:new(cache_file)
	if not cache_path:exists() then
		return false
	end

	local stat = vim.loop.fs_stat(cache_file)
	if not stat then
		return false
	end

	local age = os.time() - stat.mtime.sec
	return age < ttl
end

M.get_k8s_versions = function()
	local cache_file = M.cache_dir .. "/k8s_versions.json"

	if M.is_cache_valid(cache_file) then
		local cache_path = Path:new(cache_file)
		local cached_data = cache_path:read()
		return vim.fn.json_decode(cached_data)
	end

	local url = M.github_base_api_url .. "/yannh/kubernetes-json-schema/contents/"
	local response = curl.get(url, { headers = M.github_headers })

	if response.status ~= 200 then
		vim.notify("Failed to fetch K8s versions: " .. response.status, vim.log.levels.ERROR)
		return {}
	end

	local body = vim.fn.json_decode(response.body)
	local versions_set = {}

	for _, item in ipairs(body) do
		if item.type == "dir" then
			local base_version = item.name:match("^(v%d+%.%d+%.%d+)")
			if base_version then
				versions_set[base_version] = true
			end
		end
	end

	local versions = {}
	for version, _ in pairs(versions_set) do
		table.insert(versions, version)
	end

	table.sort(versions, function(a, b)
		local function parse_version(v)
			local major, minor, patch = v:match("^v(%d+)%.(%d+)%.(%d+)")
			return {
				major = tonumber(major) or 0,
				minor = tonumber(minor) or 0,
				patch = tonumber(patch) or 0,
			}
		end

		local va, vb = parse_version(a), parse_version(b)
		if va.major ~= vb.major then
			return va.major > vb.major
		end
		if va.minor ~= vb.minor then
			return va.minor > vb.minor
		end
		return va.patch > vb.patch
	end)

	M.ensure_cache_dir()
	Path:new(cache_file):write(vim.fn.json_encode(versions), "w")

	return versions
end

M.get_schemastore_schemas = function()
	local cache_file = M.cache_dir .. "/schemastore_catalog.json"

	if M.is_cache_valid(cache_file) then
		local cache_path = Path:new(cache_file)
		local cached_data = cache_path:read()
		return vim.fn.json_decode(cached_data)
	end

	vim.notify("Fetching SchemaStore catalog...", vim.log.levels.INFO)

	local response = curl.get(M.schemastore_api_url, {})

	if response.status ~= 200 then
		vim.notify("Failed to fetch SchemaStore catalog: " .. response.status, vim.log.levels.ERROR)
		return {}
	end

	local body = vim.fn.json_decode(response.body)
	local schemas = {}

	for _, schema in ipairs(body.schemas) do
		if schema.url then
			local file_types = {}
			if schema.fileMatch then
				for _, pattern in ipairs(schema.fileMatch) do
					if pattern:match("%.ya?ml$") then
						table.insert(file_types, "yaml")
					elseif pattern:match("%.json$") then
						table.insert(file_types, "json")
					end
				end
			end

			if #file_types == 0 then
				file_types = { "yaml", "json" }
			end

			table.insert(schemas, {
				name = schema.name,
				description = schema.description or "",
				url = schema.url,
				fileMatch = schema.fileMatch or {},
				fileTypes = file_types,
				display = schema.name .. (schema.description and (" - " .. schema.description) or ""),
			})
		end
	end

	table.sort(schemas, function(a, b)
		return a.name < b.name
	end)

	M.ensure_cache_dir()
	Path:new(cache_file):write(vim.fn.json_encode(schemas), "w")

	vim.notify("Loaded " .. #schemas .. " schemas from SchemaStore", vim.log.levels.INFO)

	return schemas
end

M.get_best_schema_folder = function(version)
	local cache_file = M.cache_dir .. "/k8s_folder_" .. version .. ".json"

	if M.is_cache_valid(cache_file, 604800) then
		local cache_path = Path:new(cache_file)
		local cached_data = cache_path:read()
		local decoded = vim.fn.json_decode(cached_data)
		if type(decoded) == "table" and decoded.folder then
			return decoded.folder
		end
		return decoded
	end

	local url = M.github_base_api_url .. "/yannh/kubernetes-json-schema/contents/"
	local response = curl.get(url, { headers = M.github_headers })

	if response.status ~= 200 then
		vim.notify("Failed to fetch schema variants: " .. response.status, vim.log.levels.ERROR)
		return nil
	end

	local body = vim.fn.json_decode(response.body)
	local variants = {}

	local version_pattern = "^" .. version:gsub("%.", "%%.")
	for _, item in ipairs(body) do
		if item.type == "dir" and item.name:match(version_pattern) then
			table.insert(variants, item.name)
		end
	end

	if #variants == 0 then
		vim.notify("No folders found for version " .. version, vim.log.levels.ERROR)
		return nil
	end

	local priority_patterns = {
		"^" .. version:gsub("%.", "%%.") .. "%-standalone$",
		"^" .. version:gsub("%.", "%%.") .. "%-standalone%-strict$",
		"^" .. version:gsub("%.", "%%.") .. "%-local$",
		"^" .. version:gsub("%.", "%%.") .. "$",
	}

	local selected_folder = nil

	for _, pattern in ipairs(priority_patterns) do
		for _, variant in ipairs(variants) do
			if variant:match(pattern) then
				selected_folder = variant
				break
			end
		end
		if selected_folder then
			break
		end
	end

	if not selected_folder then
		selected_folder = variants[1]
	end

	M.ensure_cache_dir()
	local cache_data = {
		folder = selected_folder,
		version = version,
		cached_at = os.time(),
	}
	Path:new(cache_file):write(vim.fn.json_encode(cache_data), "w")

	return selected_folder
end

M.get_k8s_schemas = function(folder)
	local cache_file = M.cache_dir .. "/k8s_schemas_" .. folder:gsub("/", "_") .. ".json"

	if M.is_cache_valid(cache_file) then
		local cache_path = Path:new(cache_file)
		local cached_data = cache_path:read()
		return vim.fn.json_decode(cached_data)
	end

	vim.notify("Fetching schemas for " .. folder .. "...", vim.log.levels.INFO)

	local tree_url = M.github_base_api_url .. "/yannh/kubernetes-json-schema/git/trees/master"
	local tree_response = curl.get(tree_url, { headers = M.github_headers })

	if tree_response.status ~= 200 then
		vim.notify("Failed to fetch tree: " .. tree_response.status, vim.log.levels.ERROR)
		return {}
	end

	local tree_body = vim.fn.json_decode(tree_response.body)
	local folder_sha = nil

	for _, item in ipairs(tree_body.tree) do
		if item.type == "tree" and item.path == folder then
			folder_sha = item.sha
			break
		end
	end

	if not folder_sha then
		vim.notify("Folder " .. folder .. " not found in git tree", vim.log.levels.ERROR)
		return {}
	end

	local folder_url = M.github_base_api_url .. "/yannh/kubernetes-json-schema/git/trees/" .. folder_sha
	local folder_response = curl.get(folder_url, {
		headers = M.github_headers,
	})

	if folder_response.status ~= 200 then
		vim.notify("Failed to fetch folder contents: " .. folder_response.status, vim.log.levels.ERROR)
		return {}
	end

	local folder_body = vim.fn.json_decode(folder_response.body)
	local schemas = {}

	for _, item in ipairs(folder_body.tree) do
		if item.type == "blob" and item.path:match("%.json$") then
			table.insert(schemas, {
				name = item.path,
				path = folder .. "/" .. item.path,
				url = M.k8s_schemas_url .. "/" .. folder .. "/" .. item.path,
			})
		end
	end

	if folder_body.truncated then
		vim.notify(
			string.format("Tree truncated. Showing %d schemas (there may be more)", #schemas),
			vim.log.levels.WARN
		)
	end

	table.sort(schemas, function(a, b)
		return a.name < b.name
	end)

	M.ensure_cache_dir()
	Path:new(cache_file):write(vim.fn.json_encode(schemas), "w")

	vim.notify("Loaded " .. #schemas .. " schemas for " .. folder, vim.log.levels.INFO)

	return schemas
end

M.list_github_tree = function()
	local cache_file = M.cache_dir .. "/crds_catalog.json"

	if M.is_cache_valid(cache_file) then
		local cache_path = Path:new(cache_file)
		local cached_data = cache_path:read()
		return vim.fn.json_decode(cached_data)
	end

	vim.notify("Fetching CRDs catalog...", vim.log.levels.INFO)

	local url = M.github_base_api_url .. "/" .. M.schemas_catalog .. "/git/trees/" .. M.schema_catalog_branch
	local response = curl.get(url, { headers = M.github_headers, query = { recursive = 1 } })

	if response.status ~= 200 then
		vim.notify("Failed to fetch CRDs catalog: " .. response.status, vim.log.levels.ERROR)
		return {}
	end

	local body = vim.fn.json_decode(response.body)
	local trees = {}

	for _, tree in ipairs(body.tree) do
		if tree.type == "blob" and tree.path:match("%.json$") then
			table.insert(trees, tree.path)
		end
	end

	M.ensure_cache_dir()
	Path:new(cache_file):write(vim.fn.json_encode(trees), "w")

	vim.notify("Loaded " .. #trees .. " CRD schemas", vim.log.levels.INFO)

	return trees
end

M.telescope_select = function(items, opts, on_select)
	local has_telescope, _ = pcall(require, "telescope")
	if not has_telescope then
		vim.notify("Telescope not found, falling back to vim.ui.select", vim.log.levels.WARN)
		vim.ui.select(items, opts, on_select)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new(opts.telescope_opts or {}, {
			prompt_title = opts.prompt or "Select",
			finder = finders.new_table({
				results = items,
				entry_maker = function(entry)
					if type(entry) == "table" then
						return {
							value = entry,
							display = entry.display or entry.name or entry.path or tostring(entry),
							ordinal = entry.name or entry.path or entry.display or tostring(entry),
						}
					else
						return {
							value = entry,
							display = entry,
							ordinal = entry,
						}
					end
				end,
			}),
			sorter = conf.generic_sorter(opts.telescope_opts or {}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						on_select(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

M.add_schema_modeline = function(schema_url)
	local schema_modeline = "# yaml-language-server: $schema=" .. schema_url
	vim.api.nvim_buf_set_lines(0, 0, 0, false, { schema_modeline })
	vim.notify("Added schema modeline: " .. schema_modeline)
end

M.select_k8s_schema = function()
	M.ensure_cache_dir()

	local versions = M.get_k8s_versions()
	if #versions == 0 then
		vim.notify("No K8s versions found", vim.log.levels.ERROR)
		return
	end

	M.telescope_select(versions, {
		prompt = "Select Kubernetes version",
		telescope_opts = {
			layout_config = { width = 0.5, height = 0.6 },
		},
	}, function(version)
		if not version then
			return
		end

		local folder = M.get_best_schema_folder(version)
		if not folder then
			vim.notify("No schema folder found for version " .. version, vim.log.levels.ERROR)
			return
		end

		vim.notify("Using schema folder: " .. folder, vim.log.levels.INFO)

		local schemas = M.get_k8s_schemas(folder)
		if #schemas == 0 then
			vim.notify("No schemas found in " .. folder, vim.log.levels.ERROR)
			return
		end

		M.telescope_select(schemas, {
			prompt = "Select schema (" .. folder .. ")",
			telescope_opts = {
				layout_config = { width = 0.7, height = 0.7 },
			},
		}, function(schema)
			if schema then
				M.add_schema_modeline(schema.url)
			end
		end)
	end)
end

M.select_crd_schema = function()
	M.ensure_cache_dir()

	local all_crds = M.list_github_tree()
	if #all_crds == 0 then
		vim.notify("No CRDs found", vim.log.levels.ERROR)
		return
	end

	M.telescope_select(all_crds, {
		prompt = "Select CRD schema",
		telescope_opts = {
			layout_config = { width = 0.8, height = 0.8 },
		},
	}, function(selection)
		if not selection then
			return
		end

		local schema_url = M.schema_url .. "/" .. selection
		M.add_schema_modeline(schema_url)
	end)
end

M.select_schemastore_schema = function()
	M.ensure_cache_dir()

	local schemas = M.get_schemastore_schemas()
	if #schemas == 0 then
		vim.notify("No SchemaStore schemas found", vim.log.levels.ERROR)
		return
	end

	M.telescope_select(schemas, {
		prompt = "Select SchemaStore schema",
		telescope_opts = {
			layout_config = { width = 0.9, height = 0.8 },
		},
	}, function(schema)
		if not schema then
			return
		end

		M.add_schema_modeline(schema.url)
	end)
end

M.clear_cache = function()
	local cache_path = Path:new(M.cache_dir)
	if cache_path:exists() then
		cache_path:rm({ recursive = true })
		M.ensure_cache_dir()
		vim.notify("Cache cleared successfully")
	end
end

M.init = function()
	M.telescope_select({
		"Kubernetes (standard)",
		"CRDs (custom)",
		"SchemaStore (general)",
	}, {
		prompt = "Select schema type",
		telescope_opts = {
			layout_config = { width = 0.5, height = 0.4 },
		},
	}, function(choice)
		if not choice then
			return
		end

		if choice:match("^Kubernetes") then
			M.select_k8s_schema()
		elseif choice:match("^CRDs") then
			M.select_crd_schema()
		elseif choice:match("^SchemaStore") then
			M.select_schemastore_schema()
		end
	end)
end

return M
