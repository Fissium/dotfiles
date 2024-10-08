local npairs = require("nvim-autopairs")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

local opts = {
	disable_filetype = { "TelescopePrompt", "vim", "helm" },
}

npairs.setup(opts)
cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done()
)

