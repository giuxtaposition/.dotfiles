vim.api.nvim_create_user_command("PackUpdate", function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names)
end, {
  nargs = "*",
  desc = "Update plugins (optionally specify names)",
})

vim.api.nvim_create_user_command("PackList", function()
  vim.pack.update(nil, { offline = true })
end, {
  desc = "List installed plugins in browsable buffer",
})

vim.api.nvim_create_user_command("PackRemove", function(opts)
  if #opts.fargs == 0 then
    vim.notify("PackRemove requires at least one plugin name", vim.log.levels.WARN)
    return
  end
  vim.pack.del(opts.fargs)
end, {
  nargs = "+",
  desc = "Remove plugins from disk",
  complete = function()
    return vim
      .iter(vim.pack.get())
      :map(function(x)
        return x.spec.name
      end)
      :totable()
  end,
})

vim.api.nvim_create_user_command("PackClean", function()
  local lockfile_path = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
  local lockfile_raw = vim.fn.readfile(lockfile_path)
  local lockfile = vim.json.decode(table.concat(lockfile_raw, "\n"))
  local lockfile_names = vim.tbl_keys(lockfile.plugins or {})

  local active_names = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  local active_set = {}
  for _, name in ipairs(active_names) do
    active_set[name] = true
  end

  local orphaned = vim
    .iter(lockfile_names)
    :filter(function(name)
      return not active_set[name]
    end)
    :totable()

  if #orphaned == 0 then
    vim.notify("No orphaned plugins to clean", vim.log.levels.INFO)
    return
  end

  table.sort(orphaned)
  vim.ui.select({ "Yes", "No" }, {
    prompt = "Remove " .. #orphaned .. " orphaned plugins? (" .. table.concat(orphaned, ", ") .. ")",
  }, function(choice)
    if choice ~= "Yes" then
      return
    end
    vim.pack.del(orphaned)
    vim.notify("Removed: " .. table.concat(orphaned, ", "), vim.log.levels.INFO)
  end)
end, {
  desc = "Remove plugins on disk but not declared in current config",
})
