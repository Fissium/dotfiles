local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.base46 = {
	theme = "chadracula",
	hl_override = highlights.override,
	hl_add = highlights.add,
}

M.ui = {

	lsp = {
		-- show function signatures i.e args as you type
		signature = {
			disabled = true,
			silent = true, -- silences 'no signature help available' message from appearing
		},
	},
}

return M
