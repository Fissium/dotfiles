local options = {

	formatters_by_ft = {
		-- lua
		lua = { "stylua" },
		-- python
		-- use ruff_lsp for python
		-- toml
		toml = { "taplo" },
		-- yaml
		yaml = { "yamlfmt" },
		-- shell
		sh = { "shfmt" },
		-- go
    -- use gopls for golang
		-- rust
    -- use rust_analyzer for rust
	},
}

require("conform").setup(options)
