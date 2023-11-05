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

	-- ChatGPT
	{
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions", "ChatGPTRun" },
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "gpg --decrypt " .. vim.fn.expand("$HOME") .. "/Documents/openai_api_key.txt.gpg",
				chat = {
					keymaps = {
						scroll_down = "<C-d>",
						draft_message = "<Nop>",
					},
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- Codeium
	{
		"Exafunction/codeium.vim",
		ft = { "python", "lua", "go", "sh" },
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
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

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
