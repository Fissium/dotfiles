local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "ruff_sort", "ruff_format" },
	-- toml
	toml = { "taplo" },
	-- yaml
	yaml = { "prettierd" },
	-- shell
	sh = { "shfmt" },
	-- go
	go = { "goimports", "gofumpt" },
	-- rust
	rust = { "rustfmt" },
	-- json
	json = { "jq" },
	-- javascript
	javascript = { "prettierd" },
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
