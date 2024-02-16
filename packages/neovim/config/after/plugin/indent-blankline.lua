local ok, indent_blankline = pcall(require, 'indent_blankline')
if not ok then
  return
end

indent_blankline.setup {
  buftype_exclude = { 'terminal', 'man', 'help', 'nofile' },
  filetype_exclude = { 'man', 'help' },
  bufname_exclude = { 'man', 'help' },
  show_trailing_blankline_indent = false,
}
