local autocmd = vim.api.nvim_create_autocmd
vim.lsp.set_log_level("off")

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

-- Helm
vim.filetype.add({
	extension = {
		gotmpl = "helm", -- For files with the ".gotmpl" extension
	},
	pattern = {
		[".*/templates/.*%.ya?ml"] = function(filename)
			return filename:match("ci.yaml") and "yaml" or "helm"
		end,
		[".*/templates/.*%.tpl"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "helm",
	callback = function()
		-- Set a custom commentstring for Helm files
		vim.opt_local.commentstring = "{{/* %s */}}"
	end,
})
