local overrides = require("configs.overrides")
local conform_opts = require("configs.conform")
local nvim_lint = require("configs.nvim-lint")
local HOME = os.getenv("HOME")

local plugins = {

	-- blink.cmp
	{ import = "nvchad.blink.lazyspec" },
	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				ghost_text = {
					enabled = false,
				},
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		cmd = "WhichKey",
		opts = function()
			dofile(vim.g.base46_cache .. "whichkey")
			return {}
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
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
			default_format_opts = conform_opts.default_format_opts,
		},
	},

	-- Linter
	{
		"mfussenegger/nvim-lint",
		event = "LspAttach",
		config = function()
			require("lint").linters_by_ft = nvim_lint.linters_by_ft
			local markdownlint_cli2 = require("lint").linters["markdownlint-cli2"]
			markdownlint_cli2.args = { "--config", HOME .. "/.markdownlint-cli2.yaml", "--" }

			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
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
		cmd = { "DiffviewOpen" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			enhanced_diff_hl = true,
			view = {
				default = { winbar_info = true },
				file_history = { winbar_info = true },
			},
			hooks = {
				diff_buf_read = function(bufnr)
					vim.b[bufnr].view_activated = false
				end,
			},
		},
	},

	-- Todo
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- schema-companion
	{
		"cenk1cenk2/schema-companion.nvim",
		ft = { "yaml" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("schema-companion").setup({
				enable_telescope = true,
				matchers = {
					require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
				},
			})
		end,
	},

	-- Markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("render-markdown").setup({
				completions = { lsp = { enabled = true } },
			})
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

	-- gitsigns
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		version = "1.0.x",
		opts = function()
			return require("nvchad.configs.gitsigns")
		end,
	},

	-- tyny-glimmer
	{
		"rachartier/tiny-glimmer.nvim",
		keys = { "u", "<c-r>" },
		opts = {
			overwrite = {
				redo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = "DiffAdd",
						},
					},
				},

				undo = {
					enabled = true,
					default_animation = {
						settings = {
							from_color = "DiffDelete",
						},
					},
				},
			},
		},
	},
}

return plugins
