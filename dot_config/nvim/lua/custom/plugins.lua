local overrides = require("custom.configs.overrides")
local conform_options = require("custom.configs.conform")

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

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = conform_options.formatters_by_ft,
      formatters = conform_options.formatters,
		},
	},

	-- smooth scroll
	{
		"karb94/neoscroll.nvim",
		keys = { "<C-d>", "<C-u>" },
		config = function()
			require("neoscroll").setup()
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

	-- Codeium
	{
		"Exafunction/codeium.vim",
    event = "InsertEnter",
		build = function()
			local bin_path = os.getenv("HOME") .. "/.codeium/bin"
			local old_binaries = vim.fs.find(function()
				return true
			end, { type = "file", limit = math.huge, path = bin_path })
			table.remove(old_binaries)
			for _, binary_path in pairs(old_binaries) do
				os.remove(binary_path)
				os.remove(vim.fs.dirname(binary_path))
			end
		end,
	},

	-- Remote edit
	{
		"chipsenkbeil/distant.nvim",
		cmd = {
			"DistantConnect",
		},
		branch = "v0.3",
		config = function()
			require("distant"):setup()
		end,
	},

	-- To make a plugin not be loaded
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
	},
}

return plugins
