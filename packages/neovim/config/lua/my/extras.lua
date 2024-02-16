-- Make neovim recognize Vagrantfiles
vim.cmd [[
  augroup filetypedetect
    au BufRead,BufNewFile Vagrantfile setfiletype ruby
  augroup END
]]

-- Set column to 72 for git commits
vim.cmd "autocmd filetype gitcommit set colorcolumn=72"

-- Hide line numbers in terminal windows
vim.api.nvim_exec([[
  au BufEnter term://* setlocal nonumber
]], false)

-- Toggle a line at column 80
vim.api.nvim_exec([[
  let g:line80=0
  function! ToggleLine80()
    if g:line80
      set colorcolumn=0
      let g:line80=0
    else
      set colorcolumn=80
      let g:line80=1
    endif
  endfunction
  command Line80 :call ToggleLine80()
]], false)
