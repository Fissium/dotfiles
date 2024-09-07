local configs = require("nvchad.configs.lspconfig")

local servers = {
	bashls = {},
	yamlls = {},
	ruff = {},
	helm_ls = {},
	dockerls = {},
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
			pyright = {
				-- Using Ruff's import organizer
				disableOrganizeImports = true,
			},
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
