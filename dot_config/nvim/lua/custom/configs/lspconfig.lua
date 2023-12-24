local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = {
	"bashls",
	"taplo",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- ruff_lsp
lspconfig.ruff_lsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			lint = {
				args = {
					"--select=ARG,F,E,I001",
					"--line-length=88",
				},
			},
		},
	},
})

-- pyright
capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "python" },
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
})
