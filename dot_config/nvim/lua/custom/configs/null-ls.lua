local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck,
  -- Python
  b.formatting.black,
  b.formatting.reorder_python_imports,
  -- Bash
  b.formatting.shfmt,
  b.code_actions.shellcheck,
  -- YAML
  b.formatting.prettierd,
  -- Docker
  b.diagnostics.hadolint,
  -- Go
  b.formatting.goimports,
  b.formatting.gofumpt,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
