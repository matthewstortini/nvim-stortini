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

vim.api.nvim_create_user_command("TemplateReplace", function(opts)
  local args = opts.fargs

  if #args == 0 or (#args % 2 ~= 0) then
    vim.notify(
      "Usage: :[range]TemplateReplace target {a,b,c} [target2 {x,y,z} ...]",
      vim.log.levels.ERROR
    )
    return
  end

  local start_line = opts.line1
  local end_line = opts.line2
  local count = end_line - start_line + 1

  local replacements = {}

  for i = 1, #args, 2 do
    local target = args[i]
    local values = parse_list(args[i + 1])

    if not values then
      vim.notify(
        "Expected list like {a,b,c} after target '" .. target .. "'",
        vim.log.levels.ERROR
      )
      return
    end

    if #values ~= count then
      vim.notify(
        string.format(
          "Replacement list for '%s' has %d items, but range has %d lines",
          target,
          #values,
          count
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

  for idx = 1, count do
    local lnum = start_line + idx - 1
    local line = vim.fn.getline(lnum)

    for _, rep in ipairs(replacements) do
      line = line:gsub(vim.pesc(rep.target), rep.values[idx], 1)
    end

    vim.fn.setline(lnum, line)
  end
end, {
  nargs = "+",
  range = true,
})
