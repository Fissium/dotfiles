local overrides = require("configs.overrides")
local conform_opts = require("configs.conform")
local yaml_opts = require("configs.yaml-companion")

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
			require("lint").linters_by_ft = {
				dockerfile = { "hadolint" },
				yaml = { "yamllint" },
			}

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
		ft = { "python", "go", "rust", "yaml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		ft = { "python", "go", "rust", "dockerfile" },
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

	-- To make a plugin not be loaded
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
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

	-- Fix helm commentstring
	{
		"numToStr/Comment.nvim",
		ft = "helm",
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

	-- Remote development
	{
		"nosduco/remote-sshfs.nvim",
		cmd = {
			"RemoteSSHFSConnect",
			"RemoteSSHFSDisconnect",
		},
		opts = {
			mounts = {
				base_dir = vim.fn.expand("$HOME") .. "/.cache/.sshfs/",
				unmount_on_exit = true,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- Jump
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
	},

	-- Git
	{
		"NeogitOrg/neogit",
		cmd = { "Neogit" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		init = function()
			local map = vim.keymap.set
			map("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit Open" })
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "neogit")
			require("neogit").setup(opts)
		end,
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
