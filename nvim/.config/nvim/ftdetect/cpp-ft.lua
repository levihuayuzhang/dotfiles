-- let nvim recognize some cpp/Qt headers if not ending with `.h` or `.hpp` (no suffix)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/Qt*/**", "*/include/**", "*/src/**" },
  callback = function()
    if vim.bo.filetype ~= "" and vim.bo.filetype ~= "text" and vim.bo.filetype ~= "conf" then
      return
    end

    -- if vim.fn.getline(1):match("#include") or vim.fn.getline(2):match("#include") then
    --   vim.bo.filetype = "cpp"
    -- end

    -- 0 for current buffer
    -- 0 and -1 means from line 0 to final line
    -- false for no line breaks
    -- local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local lines = vim.api.nvim_buf_get_lines(0, 0, 500, false) -- read 500 lines only
    local content = table.concat(lines, "\n")

    if
      content:match("#include")
      or content:match("class%s+[%w_]+")
      or content:match("namespace%s+[%w_]+")
      or content:match("template%s*<")
      or content:match("std::")
    then
      vim.bo.filetype = "cpp"
    end
  end,
})
