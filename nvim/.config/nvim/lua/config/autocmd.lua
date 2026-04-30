-- https://neovim.io/doc/user/pack/#vim.pack-events

-- -- build blink.cmp fuzzy
-- local build_blinkcmp_fuzzy = function(ev)
--   -- Use available |event-data|
--   local name, kind = ev.data.spec.name, ev.data.kind
--   -- Run build script after `blink.cmp` plugin's code has changed
--   if name == "blink.cmp" and (kind == "install" or kind == "update") then
--     -- Append `:wait()` if you need synchronous execution
--     -- vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
--     vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
--   end
--   -- If action relies on code from the plugin (like user command or
--   -- Lua code), make sure to explicitly load it first
--   if name == "blink.cmp" and kind == "update" then
--     if not ev.data.active then
--       vim.cmd.packadd("blink.cmp")
--     end
--     vim.cmd("BlinkCmpUpdate")
--     require("blink.cmp").after_update()
--   end
-- end
-- -- If hooks need to run on install, run this before `vim.pack.add()`
-- -- To act on install from lockfile, run before very first `vim.pack.add()`
-- vim.api.nvim_create_autocmd("PackChanged", { callback = build_blinkcmp_fuzzy })


-- build LuaSnip
local build_luasnip_jsregexp = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == "LuaSnip" and (kind == "install" or kind == "update") then
    vim
        .system({ "make", "install_jsregexp" }, {
          cwd = ev.data.path,
        })
        :wait()
  end
end
vim.api.nvim_create_autocmd("PackChanged", {
  callback = build_luasnip_jsregexp,
})

-- build pairs
local build_pairs = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == "blink.pairs" and (kind == "install" or kind == "update") then
    vim
        .system({ "cargo", "build", "--release" }, {
          cwd = ev.data.path,
        })
        :wait()
  end
end
vim.api.nvim_create_autocmd("PackChanged", {
  callback = build_pairs,
})


-- treesitter update
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed--update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == ("update" or "install") then
      vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping...", vim.log.levels.WARN)
      end
    end
  end,
})
