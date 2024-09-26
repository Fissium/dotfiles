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
		"gitcommit",
		"go",
		"gomod",
		"gosum",
		"helm",
		"make",
		"terraform",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
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
