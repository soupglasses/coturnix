local ok, neoscroll = pcall(require, 'neoscroll')
if not ok then
  return
end

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '100', nil}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100', nil}}
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '100', nil}}
t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '100', nil}}
t['<C-y>'] = {'scroll', {'-0.10', 'false', '100', nil}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '100', nil}}
t['zt']    = {'zt', {'100'}}
t['zz']    = {'zz', {'100'}}
t['zb']    = {'zb', {'100'}}

neoscroll.setup {
  easing_function = "quadratic",
}
require('neoscroll.config').set_mappings(t)
