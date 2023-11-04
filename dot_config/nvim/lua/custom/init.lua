vim.o.shell = "fish"

-- disable tmux
os.execute("tmux set-option -g status off")

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		vim.fn.jobstart("tmux set-option -g status on", { detach = true })
	end,
})
