local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

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
    on_init = on_init,
	})
end

-- ruff_lsp
lspconfig.ruff_lsp.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "python" },
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
})

-- rust_analyzer
lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "rust" },
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
})

-- gopls
lspconfig.gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
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