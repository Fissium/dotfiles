local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
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

	-- Codeium
	{
		"Exafunction/codeium.vim",
		ft = { "python", "go", "rust" },
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

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("custom.configs.conform")
		end,
	},

	-- smooth scroll
	{
		"karb94/neoscroll.nvim",
		keys = { "<C-d>", "<C-u>" },
		config = function()
			require("neoscroll").setup()
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	-- To make a plugin not be loaded
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
	},
}

return plugins
