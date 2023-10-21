---@type MappingsTable
local M = {}

M.ChatGPT = {

	v = {
		["<leader>cg"] = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
		["<leader>ce"] = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
		["<leader>cd"] = { "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
		["<leader>ct"] = { "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
		["<leader>co"] = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
		["<leader>cs"] = { "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
		["<leader>cf"] = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
		["<leader>cx"] = { "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
	},
	n = {
		["<leader>cg"] = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
		["<leader>ce"] = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
		["<leader>cd"] = { "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
		["<leader>ct"] = { "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
		["<leader>co"] = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
		["<leader>cs"] = { "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
		["<leader>cf"] = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
		["<leader>cx"] = { "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
	},
}

-- more keybinds!

return M
