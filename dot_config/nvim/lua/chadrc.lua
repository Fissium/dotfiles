local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.ui = {
	theme = "onedark",
	theme_toggle = { "onedark", "one_light" },

	hl_override = highlights.override,
	hl_add = highlights.add,

	lsp = {
		-- show function signatures i.e args as you type
		signature = {
			disabled = true,
			silent = true, -- silences 'no signature help available' message from appearing
		},
	},
}

return M
