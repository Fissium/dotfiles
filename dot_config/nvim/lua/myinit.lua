local autocmd = vim.api.nvim_create_autocmd
vim.lsp.set_log_level("off")
vim.o.relativenumber = true

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

-- Dockefile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.Dockefile" },
	callback = function()
		vim.bo.filetype = "Dockefile"
	end,
})

local function yaml_ft(path, bufnr)
	local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if type(content) == "table" then
		---@diagnostic disable-next-line: cast-local-type
		content = table.concat(content, "\n")
	end

	local function is_helm_file(_)
		local check = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
		return not vim.tbl_isempty(check)
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

	if is_helm_file(path) then
		return "helm"
	end

	local path_regex =
		vim.regex("/\\(ansible\\|group_vars\\|handlers\\|host_vars\\|playbooks\\|roles\\|vars\\|tasks\\)/")

	if path_regex and path_regex:match_str(path) then
		return "yaml.ansible"
	end

	local regex = vim.regex("^hosts:\\|^tasks:")

	if regex and regex:match_str(content) then
		return "yaml.ansible"
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
