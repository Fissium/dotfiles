local M = {}

M.formatters_by_ft = {

	-- lua
	lua = { "stylua" },
	-- python
	python = { "ruff_format", "isort" },
	-- toml
	toml = { "taplo" },
	-- yaml
	yaml = { "yamlfmt" },
	-- shell
	sh = { "shfmt" },
	-- go
	go = { "gofumpt", "goimports" },
	-- rust
	rust = { "rustfmt" },
}

return M
