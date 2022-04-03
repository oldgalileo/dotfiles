local pkg = {}

---@param ft string
---@param command string
pkg.setup_auto_format = function(ft, command)
  if not command then
    command = "lua vim.lsp.buf.formatting_sync()"
  end
  vim.cmd(string.format("autocmd BufWritePre *.%s %s", ft, command))
end

return pkg
