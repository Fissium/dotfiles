require("nvchad.mappings")
local map = vim.keymap.set

local mappings = {
	n = {
		["<leader>gd"] = {
			":DiffviewOpen<CR>",
			"open diffview",
		},
		["<C-i>"] = {
			function()
				local current_state = vim.lsp.inlay_hint.is_enabled()
				vim.lsp.inlay_hint.enable(not current_state)
			end,
			"toggle inlay_hint",
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
				require("telescope.builtin").diagnostics()
			end,
			"telescope show diagnostics",
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
		["<leader>Rs"] = {
			function()
				require("kulala").run()
			end,
			"send request",
		},
		["<leader>Ra"] = {
			function()
				require("kulala").run_all()
			end,
			"send all request",
		},
		["<leader>Rb"] = {
			function()
				require("kulala").scratchpad()
			end,
			"open scratchpad",
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
		["<leader>Rs"] = {
			function()
				require("kulala").run()
			end,
			"send request",
		},
		["<leader>Ra"] = {
			function()
				require("kulala").run_all()
			end,
			"send all request",
		},
	},
}

for mode, maps in pairs(mappings) do
	for key, val in pairs(maps) do
		map(mode, key, val[1], { desc = val[2] })
	end
end
