local ok, ibl = pcall(require, 'ibl')
if not ok then
  return
end

ibl.setup {
  exclude = {
    buftypes = { 'terminal', 'man', 'help', 'nofile' },
    filetypes = { 'man', 'help' },
  },
  whitespace = {
    remove_blankline_trail = true,
  },
}
