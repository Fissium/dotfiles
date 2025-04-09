local overrides = require("configs.overrides")
local conform_opts = require("configs.conform")
local nvim_remote = require("configs.nvim-remote")
local nvim_lint = require("configs.nvim-lint")

local plugins = {

	-- Override plugin definition options

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
		"hrsh7th/nvim-cmp",
		enabled = false,
	},

	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
					require("nvchad.configs.luasnip")
				end,
			},
		},

		opts_extend = { "sources.default" },

		opts = function()
			local config = require("nvchad.blink.config")
			config.keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f"] = { "scroll_documentation_down", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			}

			return config
		end,
	},

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
			require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
				settings = {
					redhat = { telemetry = { enabled = false } },
					yaml = {
						hover = true,
						completion = true,
						keyOrdering = false,
						format = {
							enable = false,
						},
						validate = true,
						schemas = {},
						schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
						schemaDownload = { enable = true },
					},
				},
			}))
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
				completions = { blink = { enabled = true } },
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

	-- Helm support
	{ "towolf/vim-helm", ft = "helm" },

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

	-- ansible-vim
	{ "pearofducks/ansible-vim", ft = { "jinja2" } },

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
