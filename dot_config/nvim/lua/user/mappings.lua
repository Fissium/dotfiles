-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  v = {
    ["<leader>ic"] = { "<cmd>ChatGPTRun complete_code<CR>", desc = "ChatGPT complete_code" },
    ["<leader>ii"]  = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
    ["<leader>ie"]  = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
    ["<leader>ig"]  = { "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
    ["<leader>it"]  = { "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
    ["<leader>ik"]  = { "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
    ["<leader>id"]  = { "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
    ["<leader>ia"]  = { "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
    ["<leader>io"]  = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
    ["<leader>is"]  = { "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
    ["<leader>if"]  = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
    ["<leader>ix"]  = { "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
    ["<leader>ir"]  = { "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
    ["<leader>il"]  = { "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
  },
  n = {
    ["<leader>ic"] = { "<cmd>ChatGPTRun complete_code<CR>", desc = "ChatGPT complete_code" },
    ["<leader>ii"]  = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
    ["<leader>ie"]  = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
    ["<leader>ig"]  = { "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
    ["<leader>it"]  = { "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
    ["<leader>ik"]  = { "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
    ["<leader>id"]  = { "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
    ["<leader>ia"]  = { "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
    ["<leader>io"]  = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
    ["<leader>is"]  = { "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
    ["<leader>if"]  = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
    ["<leader>ix"]  = { "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
    ["<leader>ir"]  = { "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
    ["<leader>il"]  = { "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<CR>", desc = "New tab" },
    ["<leader>tt"] = {
      function() require("astronvim.utils").toggle_term_cmd { cmd = "btop" } end,
      desc = "ToggleTerm btop",
    },
    ["<leader>tg"] = {
      function() require("astronvim.utils").toggle_term_cmd { cmd = "nvtop" } end,
      desc = "ToggleTerm nvtop",
    },
    ["<leader>td"] = {
      function() require("astronvim.utils").toggle_term_cmd { cmd = "lazydocker" } end,
      desc = "ToggleTerm lazydocker",
    },
    ["<leader>tr"] = {
      function() require("astronvim.utils").toggle_term_cmd { cmd = "lf" } end,
      desc = "ToggleTerm lf",
    },
    ["<leader>tu"] = {
      function() require("astronvim.utils").toggle_term_cmd { cmd = "dua i" } end,
      desc = "ToggleTerm dua",
    },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    ["<leader>i"] = { name = "GhatGPT" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
