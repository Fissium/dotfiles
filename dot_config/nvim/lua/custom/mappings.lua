---@type MappingsTable
local M = {}

vim.g.codeium_disable_bindings = 1

M.codeium = {
	i = {
		["<C-g>"] = {
			function()
				return vim.fn["codeium#Accept"]()
			end,
			"Accept completion",
			opts = { expr = true, silent = true },
		},
		["<C-n>"] = {
			function()
				return vim.fn["codeium#CycleCompletions"](1)
			end,
			"Cycle completions forward",
			opts = { expr = true, silent = true },
		},
		["<C-p"] = {
			function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end,
			"Cycle completions backward",
			opts = { expr = true, silent = true },
		},
		["<C-x>"] = {
			function()
				return vim.fn["codeium#Clear"]()
			end,
			"Clear completion",
			opts = { expr = true, silent = true },
		},
	},
}

M.neotest = {
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
	},
}

M.lsp = {
	n = {
		["<leader>fm"] = {

			function()
				require("conform").format({
					lsp_fallback = true,
					async = true,
				})
			end,
			"format with conform",
		},
	},
}

return M
