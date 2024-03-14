require("nvchad.mappings")
local map = vim.keymap.set
local fn = vim.fn

-- Options for the Codeium mappings
local function codeiumOpts(desc)
	local codeium_opts = {
		noremap = true,
		silent = true,
		expr = true,
	}
	codeium_opts.desc = desc
	return codeium_opts
end

local mappings = {
	n = {
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

map("i", "<C-g>", function()
	return fn["codeium#Accept"]()
end, codeiumOpts("Codeium accept suggestion"))
map("i", "<C-n>", function()
	return fn["codeium#CycleCompletions"](1)
end, codeiumOpts("Codeium cycle completions forwards"))
map("i", "<C-p>", function()
	return fn["codeium#CycleCompletions"](-1)
end, codeiumOpts("Codeium cycle completions backwards"))
map("i", "<C-x>", function()
	return fn["codeium#Clear"]()
end, codeiumOpts("Codeium clear completions"))
