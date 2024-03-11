require "nvchad.mappings"
local M = {}

M.neotest = {
  n = {
    ["<leader>tt"] = {
      function()
        require("neotest").run.run()
      end,
      "Run nearest test",
    },
    ["<leader>tf"] = {
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      "Run file test",
    },
    ["<leader>to"] = {
      ":Neotest output<CR>",
      "Test output",
    },
    ["<leader>ts"] = {
      ":Neotest summary<CR>",
      "Test summary",
    },
  },
}

M.git = {
  n = {
    ["<leader>gd"] = {
      ":DiffviewOpen<CR>",
      "Open diffview",
    },

    ["<leader>gc"] = {
      ":DiffviewClose<CR>",
      "Close diffview",
    },
  },
}

M.lsp = {
  n = {
    ["<leader>fm"] = {

      function()
        require("conform").format()
      end,
      "Format with conform",
    },
  },
}

return M
