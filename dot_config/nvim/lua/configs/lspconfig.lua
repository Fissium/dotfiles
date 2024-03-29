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
		cmd = { "gopls", "serve" },
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

for name, opts in pairs(servers) do
	opts.on_init = configs.on_init
	opts.on_attach = configs.on_attach

	if name == "pyright" then
		opts.capabilities = (function()
			local capabilities = configs.capabilities
			capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
			return capabilities
		end)()
	else
		opts.capabilities = configs.capabilities
	end

	require("lspconfig")[name].setup(opts)
end
