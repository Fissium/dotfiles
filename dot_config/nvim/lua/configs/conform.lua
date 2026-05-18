local options = {}

options.formatters_by_ft = {

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
	-- terraform/opentofu
	tf = { "tofu_fmt" },
	terraform = { "tofu_fmt" },
	["terraform-vars"] = { "tofu_fmt" },
	-- go
	go = { "goimports", "golines", "gofumpt" },
	-- markdown
	markdown = { "rumdl" },
	-- hcl
	hcl = { "hcl" },
	-- toml
	toml = { "tombi" },
	-- general
	["*"] = { "trim_whitespace" },
	["_"] = { lsp_format = "fallback" },
}

options.formatters = {
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

options.default_format_opts = {
	lsp_format = "fallback",
}

return options
