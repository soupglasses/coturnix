local ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
  return
end

catppuccin.setup {
  flavour = 'mocha', -- mocha, macchiato, frappe, latte
  compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
  color_overrides = {
    latte = { base = '#ffffff' }
  }
}
vim.cmd.colorscheme 'catppuccin'
