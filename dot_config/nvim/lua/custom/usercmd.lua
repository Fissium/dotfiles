local create_cmd = vim.api.nvim_create_user_command
local credentials = vim.fn.expand("$HOME/.config/distant/credentials.json")

local function read_json_file(file_path)
	local json_content = vim.fn.readfile(file_path)

	local result = vim.fn.json_decode(json_content)

	return result
end

create_cmd("SSHConnect", function()
	local data = read_json_file(credentials)

	local servers = {}
	for k, _ in pairs(data) do
		table.insert(servers, k)
	end

	vim.ui.select(servers, {
		prompt = "Select a server",
		format_item = function(item)
			return item
		end,
	}, function(server)
		if server then
			vim.cmd.DistantConnect("ssh://" .. data[server].username .. "@" .. data[server].host)
		else
			print("No server selected")
		end
	end)
end, {})
