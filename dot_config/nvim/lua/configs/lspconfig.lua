require("nvchad.configs.lspconfig").defaults()

local servers = {
	bashls = {},
	yamlls = {},
	ruff = {},
	ty = {},
	typos_lsp = {},
	helm_ls = {},
	terraformls = {},
	dockerls = {},
	docker_compose_language_service = {},
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
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
				semanticTokens = true,
			},
		},
	},
}

for name, opts in pairs(servers) do
	vim.lsp.enable(name)
	vim.lsp.config(name, opts)
end
