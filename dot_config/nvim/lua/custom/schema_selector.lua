local curl = require("plenary.curl")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {
	schemas_catalog = "datreeio/CRDs-catalog",
	schema_catalog_branch = "main",
	github_base_api_url = "https://api.github.com/repos",
	github_headers = {
		Accept = "application/vnd.github+json",
		["X-GitHub-Api-Version"] = "2022-11-28",
	},
}
M.schema_url = "https://raw.githubusercontent.com/" .. M.schemas_catalog .. "/" .. M.schema_catalog_branch

M.list_github_tree = function()
	local url = M.github_base_api_url .. "/" .. M.schemas_catalog .. "/git/trees/" .. M.schema_catalog_branch
	vim.notify("Fetching schemas from GitHub...", vim.log.levels.INFO)
	local response = curl.get(url, { headers = M.github_headers, query = { recursive = 1 } })
	if response.status ~= 200 then
		vim.notify("Failed to fetch schemas: " .. response.body, vim.log.levels.ERROR)
		return {}
	end
	vim.notify("Schemas fetched successfully!", vim.log.levels.INFO)

	local body = vim.fn.json_decode(response.body)
	local trees = {}
	if body and body.tree then
		for _, tree in ipairs(body.tree) do
			if tree.type == "blob" and tree.path:match("%.json$") then
				table.insert(trees, tree.path)
			end
		end
	end
	return trees
end

M.init = function()
	local all_crds = M.list_github_tree()

	if not all_crds or #all_crds == 0 then
		return
	end

	pickers
		.new({
			prompt_title = "Select CRD Schema",
			finder = finders.new_table({
				results = all_crds,
			}),
			sorter = conf.generic_sorter(),
			attach_mappings = function(prompt_bufnr, map)
				local function on_select()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if not selection then
						return
					end

					local selected_path = selection.value
					local schema_url = M.schema_url .. "/" .. selected_path
					local schema_modeline = "# yaml-language-server: $schema=" .. schema_url
					vim.api.nvim_buf_set_lines(0, 0, 0, false, { schema_modeline })
					vim.notify("Added schema modeline: " .. schema_modeline)
				end

				map("i", "<CR>", on_select)
				map("n", "<CR>", on_select)

				return true
			end,
		})
		:find()
end

return M
