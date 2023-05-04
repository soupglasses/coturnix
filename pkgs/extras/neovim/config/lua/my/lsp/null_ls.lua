local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    -- Generic
    diagnostics.codespell.with({ extra_args = { "-L crate" } }),
    diagnostics.trail_space,
    -- Elixir
    formatting.mix,
    -- Lua
    formatting.stylua,
    -- Nix
    formatting.alejandra,
    diagnostics.deadnix.with({ ignore_stderr = true }),
    code_actions.statix,
    -- Python
    formatting.black.with({ extra_args = { "--fast" } }),
  },
})
