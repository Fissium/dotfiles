local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "ruff_sort", "ruff_format" },
	-- yaml
	yaml = { "yamlfmt" },
	-- ansible
	ansible = { "yamlfmt" },
	-- shell
	sh = { "shfmt" },
	-- json
	json = { "jq" },
	-- terraform
	tf = { "terraform_fmt" },
	terraform = { "terraform_fmt" },
	["terraform-vars"] = { "terraform_fmt" },
	-- go
	go = { "goimports", "golines", "gofumpt" },
	-- general
	["_"] = { "trim_whitespace", lsp_format = "prefer" },
}

M.formatters = {
	ruff_sort = {
		command = "ruff",
		args = {
			"check",
			"--select",
			"I",
			"--fix",
			"--stdin-filename",
			"$FILENAME",
			"-",
		},
		stdin = true,
	},
}

M.default_format_opts = {
	lsp_format = "fallback",
}

return M
