local overrides = require("custom.configs.overrides")
local conform_options = require("custom.configs.conform")
local codeium_bin = vim.fn.expand("$HOME/.codeium/bin")
local codeium_config = vim.fn.expand("$HOME/.codeium/config.json")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- Neotest
  {
    "nvim-neotest/neotest",
    keys = { "<leader>tt", "<leader>tf" },
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
        },
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = conform_options.formatters_by_ft,
    }
  },

  -- smooth scroll
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-d>", "<C-u>" },
    config = function()
      require("neoscroll").setup()
    end,
  },

  -- Telescope fzf extension
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    opts = {
      extensions_list = { "fzf" },
    },
  },

  -- Codeium
  {
    "hrsh7th/nvim-cmp",
    config = function(_, opts)
      table.insert(opts.sources, { name = "codeium" })
      require("cmp").setup(opts)
    end,
    dependencies = {
      {
        "jcdickinson/codeium.nvim",
        config = function()
          require("codeium").setup({
            config_path = codeium_config,
            bin_path = codeium_bin,
          })
        end,
      },
    },
  },

  -- To make a plugin not be loaded
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
  },
}

return plugins
