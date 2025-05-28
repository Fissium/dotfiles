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
		"json5",
		"bash",
		"gitignore",
		"gitcommit",
		"git_config",
		"git_rebase",
		"gitattributes",
		"helm",
		"make",
		"terraform",
		"hcl",
		"nginx",
		"requirements",
		"go",
		"gomod",
		"gowork",
		"gosum",
		"diff",
		"regex",
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
