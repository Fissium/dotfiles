return {
  "jackMort/ChatGPT.nvim",
  cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions", "ChatGPTRun" },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    api_key_cmd = "gpg --decrypt " .. vim.fn.expand "$HOME" .. "/Documents/openai_api_key.txt.gpg",
    chat = {
      keymaps = {
        scroll_down = "<C-d>",
        draft_message = "<Nop>",
      },
    },
  },
}
