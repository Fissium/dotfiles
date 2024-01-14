local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "isort", "ruff_format" },
	-- toml
	toml = { "taplo" },
	-- yaml
	yaml = { "yamlfmt" },
	-- shell
	sh = { "shfmt" },
	-- go
	go = { "goimports", "gofumpt" },
	-- rust
	rust = { "rustfmt" },
}

return M
