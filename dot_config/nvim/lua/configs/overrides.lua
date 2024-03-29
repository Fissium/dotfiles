local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"dockerfile",
		"toml",
		"yaml",
		"json",
		"jsonc",
		"bash",
		"fish",
		"gitignore",
		"go",
		"gomod",
		"gosum",
		"rust",
		"make",
		"javascript",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- python stuff
		"pyright",
		"ruff-lsp",
		"ruff",

		-- bash stuff
		"bash-language-server",
		"shellcheck",
		"shfmt",

		-- yaml stuff
		"yaml-language-server",

		-- toml stuff
		"taplo",

		-- go stuff
		"gopls",
		"gofumpt",
		"goimports",

		-- rust stuff
		"rust-analyzer",

		-- javascript stuff
		"prettierd",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

return M
