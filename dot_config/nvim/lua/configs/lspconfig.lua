require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")

local servers = {
	bashls = {},
	yamlls = require("schema-companion").setup_client({
		filetypes = {
			"yaml",
			"yaml.ansible",
			"yaml.gitlab",
			"yaml.docker-compose",
			"yaml.helm-values",
		},
		settings = {
			redhat = {
				telemetry = {
					enabled = false,
				},
			},
			yaml = {
				hover = true,
				completion = true,
				keyOrdering = false,
				format = {
					enable = false,
				},
				validate = true,
				schemas = {},
				schemaStore = {
					enable = true,
					url = "https://www.schemastore.org/api/json/catalog.json",
				},
				schemaDownload = {
					enable = true,
				},
			},
		},
	}),
	ruff = {},
	-- ty = {},
	pyright = {
		settings = {
			pyright = {
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
					typeCheckingMode = "basic",
				},
			},
		},
	},
	typos_lsp = {},
	helm_ls = {},
	terraformls = {},
	docker_language_server = {},
	marksman = {},
	ansiblels = {},
	gopls = {
		settings = {
			gopls = {
				gofumpt = true,
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				analyses = {
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				usePlaceholders = true,
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = {
					"-.git",
					"-.vscode",
					"-.idea",
					"-.vscode-test",
					"-node_modules",
				},
				semanticTokens = true,
			},
		},
	},
}

for name, opts in pairs(servers) do
	if name == "pyright" then
		opts.capabilities = (function()
			local capabilities = vim.deepcopy(nvlsp.capabilities)
			capabilities.textDocument.publishDiagnostics = {
				tagSupport = { valueSet = { 2 } },
			}
			return capabilities
		end)()
	else
		opts.capabilities = nvlsp.capabilities
	end
	vim.lsp.config(name, opts)
	vim.lsp.enable(name)
end
