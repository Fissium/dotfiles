local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.base46 = {
	theme = "chadracula",
	hl_override = highlights.override,
	hl_add = highlights.add,
	integrations = { "neogit" },
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

		-- go stuff
		"gopls",
		"gofumpt",
		"goimports",

		-- docker stuff
		"hadolint",
		"dockerfile-language-server",

    -- markdown
    "marksman",
	},
}

return M
