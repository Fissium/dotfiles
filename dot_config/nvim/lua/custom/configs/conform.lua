local options = {

	formatters_by_ft = {
		-- lua
		lua = { "stylua" },
		-- python
		python = { "ruff_format" },
		-- toml
		toml = { "taplo" },

		-- yaml
		yaml = { "yamlfmt" },
		-- shell
		sh = { "shfmt" },
	},
}

require("conform").setup(options)
