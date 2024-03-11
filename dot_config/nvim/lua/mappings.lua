require("nvchad.mappings")
local map = vim.keymap.set

local mappings = {
	n = {
		["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
		["<C-i>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
		["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
		["<leader>tt"] = {
			function()
				require("neotest").run.run()
			end,
			"Run nearest test",
		},
		["<leader>tf"] = {
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			"Run file test",
		},
		["<leader>to"] = {
			":Neotest output<CR>",
			"Test output",
		},
		["<leader>ts"] = {
			":Neotest summary<CR>",
			"Test summary",
		},
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
	},
}

for mode, maps in pairs(mappings) do
	for key, val in pairs(maps) do
		map(mode, key, val[1], { desc = val[2] })
	end
end
