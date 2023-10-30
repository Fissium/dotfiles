---@type MappingsTable
local M = {}

M.ChatGPT = {

	v = {
		["<leader>cg"] = { "<cmd>ChatGPT<CR>", "ChatGPT" },
		["<leader>ce"] = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
		["<leader>cd"] = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
		["<leader>ct"] = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
		["<leader>co"] = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
		["<leader>cs"] = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
		["<leader>cf"] = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
		["<leader>cx"] = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
	},
	n = {
		["<leader>cg"] = { "<cmd>ChatGPT<CR>", "ChatGPT" },
		["<leader>ce"] = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
		["<leader>cd"] = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
		["<leader>ct"] = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
		["<leader>co"] = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
		["<leader>cs"] = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
		["<leader>cf"] = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
		["<leader>cx"] = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
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

-- more keybinds!

return M
