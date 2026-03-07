local function parse_list(str)
	local inner = str:match("^%{(.*)%}$")
	if not inner then
		return nil
	end

	local items = {}
	for item in inner:gmatch("([^,]+)") do
		table.insert(items, vim.trim(item))
	end
	return items
end

local function get_template_line()
	local reg = vim.fn.getreg("0")
	if reg == nil or reg == "" then
		return nil, "Register 0 is empty. Yank a line first."
	end

	local lines = vim.split(reg, "\n", { plain = true })

	if #lines > 0 and lines[#lines] == "" then
		table.remove(lines, #lines)
	end

	if #lines ~= 1 then
		return nil, "TemplatePaste currently expects exactly one yanked line."
	end

	return lines[1], nil
end

vim.api.nvim_create_user_command("TemplatePaste", function(opts)
	local args = opts.fargs

	if #args == 0 or (#args % 2 ~= 0) then
		vim.notify("Usage: :TemplatePaste target {a,b,c} [target2 {x,y,z} ...]", vim.log.levels.ERROR)
		return
	end

	local template, err = get_template_line()
	if not template then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local replacements = {}
	local count = nil

	for i = 1, #args, 2 do
		local target = args[i]
		local values = parse_list(args[i + 1])

		if not values then
			vim.notify("Expected list like {a,b,c} after target '" .. target .. "'", vim.log.levels.ERROR)
			return
		end

		if count == nil then
			count = #values
			if count == 0 then
				vim.notify("Replacement lists cannot be empty", vim.log.levels.ERROR)
				return
			end
		elseif #values ~= count then
			vim.notify(
				string.format(
					"All replacement lists must have the same length (expected %d, got %d for '%s')",
					count,
					#values,
					target
				),
				vim.log.levels.ERROR
			)
			return
		end

		table.insert(replacements, {
			target = target,
			values = values,
		})
	end

	local out = {}

	for idx = 1, count do
		local line = template
		for _, rep in ipairs(replacements) do
			line = line:gsub(vim.pesc(rep.target), rep.values[idx], 1)
		end
		table.insert(out, line)
	end

	vim.api.nvim_put(out, "l", true, true)
end, {
	nargs = "+",
})
