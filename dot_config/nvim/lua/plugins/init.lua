local overrides = require("configs.overrides")
local conform_opts = require("configs.conform")
local yaml_opts = require("configs.yaml-companion")
local nvim_remote = require("configs.nvim-remote")
local nvim_lint = require("configs.nvim-lint")

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

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = conform_opts.formatters_by_ft,
			formatters = conform_opts.formatters,
		},
	},

	-- Linter
	{
		"mfussenegger/nvim-lint",
		event = "LspAttach",
		config = function()
			require("lint").linters_by_ft = nvim_lint.linters_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
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

	-- Diffview
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	-- Todo
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- K8S
	{
		"someone-stole-my-name/yaml-companion.nvim",
		ft = { "yaml" },
		opts = yaml_opts.opts,
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function(_, opts)
			local cfg = require("yaml-companion").setup(opts)
			require("lspconfig")["yamlls"].setup(cfg)
			require("telescope").load_extension("yaml_schema")
		end,
	},

	-- Markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},

	-- Override nvim-autopairs
	{
		"windwp/nvim-autopairs",
		dependencies = { "hrsh7th/nvim-cmp" },
		event = "InsertEnter",
		config = function()
			require("configs.nvim-autopairs")
		end,
	},

	-- Commentstring
	{
		"numToStr/Comment.nvim",
		ft = { "helm", "terraform" },
		config = function()
			require("Comment").setup({
				pre_hook = function()
					if vim.bo.filetype == "helm" then
						return "{{/* %s */}}"
					end
				end,
			})
		end,
	},

	-- Helm support
	{ "towolf/vim-helm", ft = "helm" },

	-- Chezmoi support
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},

	-- Remote development
	{
		"amitds1997/remote-nvim.nvim",
		version = "*",
		cmd = { "RemoteStart" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = nvim_remote.opts,
	},

	-- search/replace in multiple files
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
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
