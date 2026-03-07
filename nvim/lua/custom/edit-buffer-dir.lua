-- have ":E" expand to ":e <directory-of-current-buffer>/"
vim.keymap.set("c", "<Space>", function()
	if vim.fn.getcmdtype() ~= ":" then
		return " "
	end
	local line = vim.fn.getcmdline()
	local pos = vim.fn.getcmdpos()
	if pos == #line + 1 and line:match("^%s*E$") then
		local dir = vim.fn.expand("%:p:h")
		if dir == "" then
			dir = vim.fn.getcwd()
		end
		return vim.api.nvim_replace_termcodes("<C-u>e " .. dir .. "/", true, false, true)
	end
	return " "
end, { expr = true })
