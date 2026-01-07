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
			sources = {
				per_filetype = {
					markdown = { inherit_defaults = true },
				},
				default = { "lsp", "snippets", "buffer", "path" },
			},
		},
	},

	-- Markdown TOC
	{
		"hedyhli/markdown-toc.nvim",
		ft = "markdown",
		cmd = { "Mtoc" },
		opts = {
			toc_list = {
				markers = "-",
			},
		},
	},

	-- Kulala
	{
		"mistweaverco/kulala.nvim",
		ft = "http",
		opts = {},
	},

	-- Hardtime
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disabled_filetypes = { "NvimTree", "lazy", "mason", "json.kulala_ui", "grug-far", "text.kulala_ui" },
			resetting_keys = {
				["y"] = {},
				["p"] = {},
			},
		},
	},

  -- WhichKey
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		cmd = "WhichKey",
		opts = function()
			dofile(vim.g.base46_cache .. "whichkey")
			return {}
		end,
	},

  -- LspConfig
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

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},

		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	-- Diffview
	{
		"esmuellert/vscode-diff.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
	},

	-- Todo
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- Markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = {
				blink = {
					enabled = true,
				},
			},
			overrides = {
				buftype = {
					nofile = {
						enabled = false,
					},
				},
			},
		},
	},

	-- Commentstring
	{
		"numToStr/Comment.nvim",
		ft = { "helm" },
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
