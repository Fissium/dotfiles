local autocmd = vim.api.nvim_create_autocmd
vim.lsp.set_log_level("off")
vim.o.relativenumber = true

dofile(vim.g.base46_cache .. "render-markdown")

if vim.fn.executable("zsh") == 1 then
	vim.o.shell = "zsh"
else
	vim.o.shell = "bash"
end

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if
			line > 1
			and line <= vim.fn.line("$")
			and vim.bo.filetype ~= "commit"
			and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
		then
			vim.cmd('normal! g`"')
		end
	end,
})

autocmd("BufEnter", {
	callback = function()
		if vim.fn.winnr("$") == 1 and vim.bo.filetype == "NvimTree" then
			vim.cmd("q")
		end
	end,
})

-- Dockefile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.Dockefile" },
	callback = function()
		vim.bo.filetype = "Dockefile"
	end,
})

local function yaml_ft(path, bufnr)
	local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local function is_helm_file()
		local check = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
		if vim.tbl_isempty(check) then
			return false
		end
		if path:match("Chart%.ya?ml$") or path:match("values%..*%.ya?ml$") or path:match("values%.ya?ml$") then
			return false
		end
		return true
	end

	local function is_gitlab_ci_file()
		return path:match("%.gitlab%-ci.*%.ya?ml$") or path:match("[cC][iI][cC][dD].*%.ya?ml$")
	end

	local function is_docker_compose_file()
		return path:match("docker%-compose%.ya?ml$") or path:match(".*%.docker%-compose%.ya?ml$")
	end

	if is_helm_file() then
		return "helm"
	elseif is_gitlab_ci_file() then
		return "yaml.gitlab"
	elseif is_docker_compose_file() then
		return "yaml.docker-compose"
	end

	local path_regex =
		vim.regex("/\\(ansible\\|group_vars\\|handlers\\|host_vars\\|playbooks\\|roles\\|vars\\|tasks\\)/")

	if path_regex and path_regex:match_str(path) then
		return "yaml.ansible"
	end

	local max_lines = math.min(#content, 20)

	for i = 1, max_lines do
		local line = content[i]
		if
			line
			and (
				line:match("^%s*-%s*hosts:")
				or line:match("^%s*hosts:")
				or line:match("^%s*tasks:")
				or line:match("^%s*roles:")
				or line:match("^%s*handlers:")
			)
		then
			return "yaml.ansible"
		end
	end

	return "yaml"
end

-- Helm, Ansible, Gitlab CI/CD, Docker Compose
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yml", "*.yaml" },
	callback = function()
		local ft = yaml_ft(vim.fn.expand("%:p"), vim.fn.bufnr("%"))
		vim.bo.filetype = ft
	end,
})

-- Env
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { ".envrc" },
	callback = function()
		vim.bo.filetype = "sh"
	end,
})

-- Jinja
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.j2" },
	callback = function()
		vim.bo.filetype = "jinja"
	end,
})

-- go
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.expandtab = false
	end,
})

-- ruff
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})
