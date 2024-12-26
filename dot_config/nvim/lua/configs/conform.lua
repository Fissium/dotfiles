local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "ruff_organize_imports", "ruff_format" },
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
}

M.formatters = {
	ruff_sort = {
		command = "ruff",
		args = {
			"check",
			"--fix",
			"--select",
			"I",
			"--stdin-filename",
			"$FILENAME",
			"-",
		},
		stdin = true,
	},
}

return M
