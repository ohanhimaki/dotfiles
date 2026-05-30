vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {})

vim.api.nvim_create_user_command("DotnetToolsUpdate", function()
	local tools = {
		{ "roslyn-language-server", "--prerelease" },
		{ "EasyDotnet", "" },
	}
	for _, tool in ipairs(tools) do
		local name, args = tool[1], tool[2]
		local cmd = ("dotnet tool update -g %s %s"):format(name, args):gsub("%s+$", "")
		vim.notify("Running: " .. cmd, vim.log.levels.INFO)
		vim.fn.jobstart(cmd, {
			on_exit = function(_, code)
				if code == 0 then
					vim.notify(name .. " updated ok", vim.log.levels.INFO)
				else
					vim.notify(name .. " failed (exit " .. code .. ")", vim.log.levels.ERROR)
				end
			end,
		})
	end
end, { desc = "Install/update roslyn-language-server and EasyDotnet global tools" })
