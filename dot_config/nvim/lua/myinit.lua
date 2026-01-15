local autocmd = vim.api.nvim_create_autocmd
vim.lsp.set_log_level("off")
vim.o.relativenumber = true

dofile(vim.g.base46_cache .. "render-markdown")
dofile(vim.g.base46_cache .. "todo")

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

-- Filetypes
vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
		http = "http",
	},

	filename = {
		["Dockerfile"] = "dockerfile",
	},
	pattern = {
		-- Jinja
		["*.j2"] = "jinja",

		-- HAProxy
		["haproxy*.cfg"] = "haproxy",

		-- Env
		[".envrc"] = "sh",

		-- Docker
		["*.Dockerfile"] = "dockerfile",

		-- Docker Compose
		[".*docker%-compose.*%.ya?ml"] = "yaml.docker-compose",

		-- GitLab CI
		[".*gitlab%-ci.*%.ya?ml"] = "yaml.gitlab",
		[".*[cC][iI][cC][dD].*%.ya?ml"] = "yaml.gitlab",

		-- Helm
		[".*/templates/.*%.tpl"] = "helm",
		[".*/templates/.*%.ya?ml"] = function(path, _)
			local chart = vim.fs.find({ "Chart.yaml", "Chart.yml" }, {
				path = vim.fs.dirname(path),
				upward = true,
			})
			return not vim.tbl_isempty(chart) and "helm" or "yaml"
		end,
		[".*/templates/.*%.txt"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
		["helmfile.*%.ya?ml.gotmpl"] = "helm",
		["values.*%.ya?ml"] = "yaml.helm-values",
		["Chart.yaml"] = "yaml",

		-- Ansible
		[".*/defaults/.*%.ya?ml"] = "yaml.ansible",
		[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
		[".*/playbook.*%.ya?ml"] = "yaml.ansible",
		[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
		[".*/tasks/.*%.ya?ml"] = "yaml.ansible",
		[".*/molecule/.*%.ya?ml"] = "yaml.ansible",
		[".*/handlers/.*%.ya?ml"] = "yaml.ansible",
		[".*/vars/.*%.ya?ml"] = "yaml.ansible",
	},
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
