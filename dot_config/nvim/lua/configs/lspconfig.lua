local configs = require("nvchad.configs.lspconfig")

local servers = {
	bashls = {},
	taplo = {},
	yamlls = {},

	ruff_lsp = {
		init_options = {
			settings = {
				-- Any extra CLI arguments for `ruff` go here.
				lint = {
					args = {
						"--select=ARG,F,E,W,B,C4,UP,RUF",
						"--line-length=88",
					},
				},
			},
		},
	},

	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
				},
				cargo = {
					allFeatures = true,
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},

	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
			},
		},
	},

	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
					typeCheckingMode = "basis",
				},
			},
		},
	},
}

for name, opts in ipairs(servers) do
	opts.on_init = configs.on_init
	opts.on_attach = configs.on_attach
	opts.capabilities = configs.capabilities

	require("lspconfig")[name].setup(opts)
end
