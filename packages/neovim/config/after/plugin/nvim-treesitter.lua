local ok, _ = pcall(require, 'nvim-treesitter')
if not ok then
  return
end

require('nvim-treesitter.configs').setup {
  ensure_installed = {}, -- WORKAROUND: https://github.com/NixOS/nixpkgs/issues/189838
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {
      'markdown' -- for vim-pandoc-syntax
    },
  },
  indent = { enable = true },
  refactor = { smart_rename = true, keymaps = { smart_rename = "<Leader>r" }},
}
