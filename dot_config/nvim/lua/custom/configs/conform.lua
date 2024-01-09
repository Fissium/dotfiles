local M = {}

M.formatters_by_ft = {
  -- lua
  lua = { "stylua" },
  -- python
  -- use ruff_lsp for python
  -- toml
  -- use taplo for toml
  -- yaml
  yaml = { "yamlfmt" },
  -- shell
  sh = { "shfmt" },
  -- go
  -- use gopls for golang
  -- rust
  -- use rust_analyzer for rust
}

return M
