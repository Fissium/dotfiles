local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.base46 = {
	theme = "chadracula",
	hl_override = highlights.override,
	hl_add = highlights.add,
	integrations = { "render-markdown", "diffview" },
}

M.lsp = {
	signature = true,
}

M.ui = {
	cmp = {
		icons_left = true,
		lspkind_text = true,
		style = "atom_colored",
	},

	statusline = {
		enabled = true,
		theme = "minimal",
		separator_style = "round",
	},
}

M.mason = {
	cmd = true,
	pkgs = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- python stuff
		"pyright",
		"ruff",

		-- bash stuff
		"bash-language-server",
		"shellcheck",
		"shfmt",

		-- yaml stuff
		"yaml-language-server",
		"yamlfmt",
		"yamllint",

		-- docker stuff
		"hadolint",
		"dockerfile-language-server",

		-- markdown
		"marksman",

		-- typos
		"typos-lsp",

		-- helm
		"helm-ls",

		-- terraform
		"terraform-ls",
		"tflint",

		-- ansible
		"ansible-language-server",
		"ansible-lint",

		-- go
		"goimports",
		"gofumpt",
		"gopls",
		"golines",
	},
}

M.colorify = {
	enabled = false,
}

return M
