local options = {

	formatters_by_ft = {
		-- lua
		lua = { "stylua" },
		-- python
		-- use language server for python
		-- toml
		toml = { "taplo" },
		-- yaml
		yaml = { "yamlfmt" },
		-- shell
		sh = { "shfmt" },
		-- go
		go = { "gofmt", "goimports", "golines" },
		-- rust
		rust = { "rustfmt" },
	},
}

require("conform").setup(options)
