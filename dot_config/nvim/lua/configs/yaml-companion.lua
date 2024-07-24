local M = {}

M.opts = {
	builtin_matchers = {
		kubernetes = { enabled = true },
		cloud_init = { enabled = true },
	},

	schemas = {},

	lspconfig = {
		flags = {
			debounce_text_changes = 150,
		},
		settings = {
			redhat = { telemetry = { enabled = false } },
			yaml = {
				validate = true,
				format = { enable = true },
				hover = true,
				schemaStore = {
					enable = true,
					url = "https://www.schemastore.org/api/json/catalog.json",
				},
				schemaDownload = { enable = true },
				schemas = {},
				trace = { server = "debug" },
			},
		},
	},
}

return M
