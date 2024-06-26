local overrides = require("configs.overrides")
local conform_options = require("configs.conform")

local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
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
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
				},
			})
		end,
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = conform_options.formatters_by_ft,
			formatters = conform_options.formatters,
		},
	},

	-- Smooth scroll
	{
		"karb94/neoscroll.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local opts = {
				mappings = {
					"<C-u>",
					"<C-d>",
				},
			}
			require("neoscroll").setup(opts)
		end,
	},

	-- Telescope fzf extension
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		opts = {
			extensions_list = { "fzf" },
		},
	},

	-- Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		ft = { "python", "go", "rust" },
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<C-g>",
						accept_word = false,
						accept_line = false,
						next = "<C-n>",
						prev = "<C-p>",
						dismiss = "<C-x>",
					},
				},
			})
		end,
	},

	-- Diffview
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	-- Hlargs
	{
		"m-demare/hlargs.nvim",
		ft = { "python", "go", "rust" },
		config = function()
			require("hlargs").setup({
				hl_priority = 200,
			})
		end,
	},

	-- Todo
	{
		"folke/todo-comments.nvim",
		ft = { "python", "go", "rust" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- To make a plugin not be loaded
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
	},

	-- Nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = { enable = true },
		},
	},
}

return plugins
