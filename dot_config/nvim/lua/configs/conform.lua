local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "ruff_sort", "ruff_format" },
	-- yaml
	yaml = { "yamlfmt" },
	-- ansible
	ansible = { "yamlfmt", "ansible-lint" },
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
	-- markdown
	markdown = { "rumdl" },
	-- general
	["*"] = { "trim_whitespace" },
	["_"] = { lsp_format = "fallback" },
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
	["ansible-lint"] = {
		prepend_args = { "--offline" },
	},
}

M.default_format_opts = {
	lsp_format = "fallback",
	timeout_ms = 5000,
}

return M
