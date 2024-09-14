require("nvchad.mappings")
local map = vim.keymap.set

local mappings = {
	n = {
		["<leader>gd"] = {
			":DiffviewOpen<CR>",
			"open diffview",
		},

		["<leader>gc"] = {
			":DiffviewClose<CR>",
			"close diffview",
		},
		["<leader>fm"] = {

			function()
				require("conform").format()
			end,
			"format with conform",
		},
		["<leader>yc"] = {
			":Telescope yaml_schema<CR>",
			"select a schema for the current buffer",
		},
		["<leader>rc"] = {
			":RemoteSSHFSConnect<CR>",
			"sshfs connect",
		},
		["<leader>rd"] = {
			":RemoteSSHFSDisconnect<CR>",
			"sshfs disconnect",
		},
		["<leader>fd"] = {
			function()
				require("telescope.builtin").live_grep({
					additional_args = function()
						return { "--hidden", "--no-ignore" }
					end,
				})
			end,
			"telescope live grep all files",
		},
		["<leader>sr"] = {
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.grug_far({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			"search and replace",
		},
		["s"] = {
			function()
				require("flash").jump()
			end,
			"Flash",
		},
		["S"] = {
			function()
				require("flash").treesitter()
			end,
			"Flash Treesitter",
		},
		["R"] = {
			function()
				require("flash").treesitter_search()
			end,
			"Treesitter Search",
		},
	},

	v = {
		["<leader>sr"] = {
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.grug_far({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			"search and replace",
		},
	},

	o = {
		["r"] = {
			function()
				require("flash").remote()
			end,
			"Remote Flash",
		},
		["R"] = {
			function()
				require("flash").treesitter_search()
			end,
			"Treesitter Search",
		},
	},

	x = {
		["s"] = {
			function()
				require("flash").jump()
			end,
			"Flash",
		},
		["S"] = {
			function()
				require("flash").treesitter()
			end,
			"Flash Treesitter",
		},
		["R"] = {
			function()
				require("flash").treesitter_search()
			end,
			"Treesitter Search",
		},
	},

	c = {
		["<c-s>"] = {
			function()
				require("flash").toggle()
			end,
			"Toggle Flash Search",
		},
	},
}

for mode, maps in pairs(mappings) do
	for key, val in pairs(maps) do
		map(mode, key, val[1], { desc = val[2] })
	end
end
