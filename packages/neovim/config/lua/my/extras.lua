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

function Line(pos)
    pos = pos or ''
    if vim.api.nvim_get_option_value('colorcolumn', {scope = "local"}) == tostring(pos) then
        vim.api.nvim_set_option_value('colorcolumn', '', {scope = "local"})
    else
        vim.api.nvim_set_option_value('colorcolumn', tostring(pos), {scope = "local"})
    end
end
vim.cmd("command! -nargs=? Line lua Line(<args>)")
vim.cmd("command! Line80 lua Line(80)")
vim.cmd("command! Line100 lua Line(100)")
