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

-- Helm filetype
local is_helm_file = function(path)
	local check = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
	return not vim.tbl_isempty(check)
end

-- exclude gitlab-ci.yaml
local is_gitlab_ci_file = function(path)
	return path:match("templates/.*%.gitlab%-ci%.ya?ml$") ~= nil
end

local yaml_filetype = function(path, _)
	if is_gitlab_ci_file(path) then
		return "yaml"
	elseif is_helm_file(path) then
		return "helm"
	else
		return "yaml"
	end
end

local tmpl_filetype = function(path, _)
	return is_helm_file(path) and "helm" or "template"
end
local tpl_filetype = function(path, _)
	return is_helm_file(path) and "helm" or "smarty"
end

vim.filetype.add({
	extension = {
		gotmpl = "helm",
		yaml = yaml_filetype,
		yml = yaml_filetype,
		tmpl = tmpl_filetype,
		tpl = tpl_filetype,
	},
	filename = {
		["Chart.yaml"] = "yaml",
		["Chart.lock"] = "yaml",
	},
	pattern = {
		["helmfile.*%.ya?ml"] = "helm",
		["templates/.*%.gitlab%-ci%.ya?ml"] = "yaml",
	},
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = vim.api.nvim_create_augroup("FixHelmCommentString", { clear = true }),
-- 	callback = function(ev)
-- 		vim.bo[ev.buf].commentstring = "{{/* %s */}}"
-- 	end,
-- 	pattern = { "helm" },
-- })

-- Terraform
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
-- 	callback = function(ev)
-- 		vim.bo[ev.buf].commentstring = "# %s"
-- 	end,
-- 	pattern = { "terraform", "hcl" },
-- })
