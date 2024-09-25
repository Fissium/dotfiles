local M = {}

M.opts = {
	client_callback = function(port, workspace_config)
		local cmd
		if vim.env.TERM == "xterm-kitty" then
			cmd = string.format(
				'kitten @ launch --type=tab --tab-title "Remote: %s" nvim --server localhost:%d --remote-ui',
				workspace_config.host,
				port
			)
		end
		if cmd then
			vim.fn.jobstart(cmd, {
				detach = true,
				on_exit = function(job_id, exit_code, event_type)
					print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
				end,
			})
		else
			print("Unsupported terminal. Command not set.")
		end
	end,
}

return M
