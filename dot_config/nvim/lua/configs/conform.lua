local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "ruff_sort", "ruff_organize_imports" },
	-- toml
	toml = { "taplo" },
	-- yaml
	yaml = { "yamlfmt" },
	-- shell
	sh = { "shfmt" },
	-- go
	go = { "goimports", "gofumpt" },
	-- rust
	-- json
	json = { "jq" },
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
