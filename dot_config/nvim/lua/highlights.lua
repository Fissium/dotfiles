-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

M.override = {
	Comment = {
		italic = true,
	},
}

M.add = {
	NvimTreeOpenedFolderName = { fg = "green", bold = true },
	St_schema = { fg = "#6f737b", bold = true },
}

return M
