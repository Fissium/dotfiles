require("nvchad.mappings")
local map = vim.keymap.set

local mappings = {
	n = {
		["<leader>gd"] = {
			":DiffviewOpen<CR>",
			"open diffview",
		},

		["<leader>gc"] = {
			":DiffviewClose<CR>",
			"close diffview",
		},
		["<leader>gb"] = {
			":Gitsigns blame<CR>",
			"git blame",
		},
		["<leader>fm"] = {
			function()
				require("conform").format()
			end,
			"format with conform",
		},
		["<leader>yc"] = {
			function()
				require("telescope").extensions.schema_companion.select_schema()
			end,
			"select a schema for the current buffer",
		},
		["<leader>ym"] = {
			function()
				require("telescope").extensions.schema_companion.select_from_matching_schemas()
			end,
			"select a matched schema for the current buffer",
		},
		["<leader>fd"] = {
			function()
				require("telescope.builtin").live_grep({
					additional_args = function()
						return { "--hidden", "--no-ignore" }
					end,
				})
			end,
			"telescope live grep all files",
		},
		["<leader>sr"] = {
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			"search and replace",
		},
	},

	v = {
		["<leader>sr"] = {
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			"search and replace",
		},
	},
}

for mode, maps in pairs(mappings) do
	for key, val in pairs(maps) do
		map(mode, key, val[1], { desc = val[2] })
	end
end
