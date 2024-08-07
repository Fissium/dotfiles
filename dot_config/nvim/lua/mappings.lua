require("nvchad.mappings")
local map = vim.keymap.set

local mappings = {
	n = {
		["<leader>gd"] = {
			":DiffviewOpen<CR>",
			"Open diffview",
		},

		["<leader>gc"] = {
			":DiffviewClose<CR>",
			"Close diffview",
		},
		["<leader>fm"] = {

			function()
				require("conform").format()
			end,
			"Format with conform",
		},
		["<leader>yc"] = {
			":Telescope yaml_schema<CR>",
			"Select a schema for the current buffer",
		},
	},
}

for mode, maps in pairs(mappings) do
	for key, val in pairs(maps) do
		map(mode, key, val[1], { desc = val[2] })
	end
end
