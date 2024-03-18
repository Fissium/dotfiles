require("nvchad.options")

local o = vim.o
local g = vim.g

o.shell = "fish"
g.copilot_proxy = "http://localhost:1080"
g.codeium_disable_bindings = 1
