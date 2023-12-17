local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"nvimtools/none-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	-- Neotest
	{
		"nvim-neotest/neotest",
		keys = { "<leader>tt", "<leader>tf" },
		dependencies = {
			"nvim-neotest/neotest-python",
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
				},
			})
		end,
	},

	--SnipRun
	{
		"michaelb/sniprun",
		event = { "BufEnter *.py" },
		build = "bash ./install.sh",
		config = function()
			require("sniprun").setup({
				selected_interpreters = { "Python3_fifo" },
				repl_enable = { "Python3_fifo" },
				display = {
					"Classic",
				},
			})
			vim.api.nvim_set_keymap("v", "<leader>rl", "<Plug>SnipRun", { silent = true })
			vim.api.nvim_set_keymap("n", "<leader>rl", "<Plug>SnipRun", { silent = true })
			vim.api.nvim_set_keymap("n", "<leader>rm", "<Plug>SnipReplMemoryClean", { silent = true })
			vim.api.nvim_set_keymap("n", "<leader>rc", "<Plug>SnipReset", { silent = true })
			vim.api.nvim_set_keymap("n", "<leader>rq", "<Plug>SnipClose", { silent = true })
		end,
	},

	--Codeium
	{
		"Exafunction/codeium.vim",
		event = { "BufEnter *.py" },
		config = function()
			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<C-n>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<C-p", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
		end,
	},

	-- To make a plugin not be loaded
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
	},

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
