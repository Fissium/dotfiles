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
