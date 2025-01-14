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

-- Gitlab
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.gitlab-ci*.{yml,yaml}", "*cicd*.{yml,yaml}" },
	callback = function()
		vim.bo.filetype = "yaml.gitlab"
	end,
})

-- Dockefile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.Dockefile" },
	callback = function()
		vim.bo.filetype = "Dockefile"
	end,
})

-- Ansible
local function yaml_ft(path, bufnr)
	local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if type(content) == "table" then
		content = table.concat(content, "\n")
	end

	local path_regex =
		vim.regex("/\\(ansible\\|group_vars\\|handlers\\|host_vars\\|playbooks\\|roles\\|vars\\|tasks\\)/")

	if path_regex and path_regex:match_str(path) then
		return "yaml.ansible"
	end

	local regex = vim.regex("hosts:\\|tasks:")

	if regex and regex:match_str(content) then
		return "yaml.ansible"
	end

	return "yaml"
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yml", "*.yaml" },
	callback = function()
		local ft = yaml_ft(vim.fn.expand("%:p"), vim.fn.bufnr("%"))
		vim.bo.filetype = ft
	end,
})
