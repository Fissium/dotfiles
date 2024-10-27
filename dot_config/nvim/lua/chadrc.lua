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
		order = {
			"mode",
			"file",
			"yaml_schema",
			"git",
			"%=",
			"lsp_msg",
			"%=",
			"diagnostics",
			"lsp",
			"cwd",
			"cursor",
		},
		modules = {
			yaml_schema = function()
				local schema = require("yaml-companion").get_buf_schema(0)
				if schema.result[1].name == "none" then
					return ""
				end
				return "%#St_schema#" .. schema.result[1].name
			end,
		},
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
	},
}

return M
