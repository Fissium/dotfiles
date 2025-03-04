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
		"gitignore",
		"gitcommit",
		"helm",
		"make",
		"terraform",
		"hcl",
		"nginx",
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
