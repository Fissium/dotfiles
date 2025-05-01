local nvlsp = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")

nvlsp.defaults()

local servers = {
	bashls = {},
	yamlls = {},
	ruff = {},
	helm_ls = {},
	terraformls = {},
	dockerls = {},
	docker_compose_language_service = {},
	marksman = {},
	ansiblels = {},
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
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
				semanticTokens = true,
			},
		},
	},
}

for name, opts in pairs(servers) do
	opts.on_init = nvlsp.on_init
	opts.on_attach = nvlsp.on_attach

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

	lspconfig[name].setup(opts)
end
