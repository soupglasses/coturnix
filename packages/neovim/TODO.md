# Neovim TODO

## Set up `set runtimepath^=${runtime}/etc` to stop imports of `~/.config/nvim`.
Can use ideas from `neovim-runtime` in https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/neovim.nix
- https://github.com/jakehamilton/neovim/blob/720f3d913e2ef2a8d9c2ca1419a28a27c3e750cd/packages/neovim/default.nix#L48-L55

## Further test possible issues with `:cd` causing `$PATH` nuking.
Might be an issue related to `direnv.vim`?
- https://matrix.to/#/!KqkRjyTEzAGRiZFBYT:nixos.org/$6NCrJ3UOBOYLP_Nt6S4jsQekm-zsccoARQ9_ei0cEa8?via=nixos.org&via=matrix.org&via=tchncs.de

## Look into pinning lspservers for each `.setup` section.
Would not require messing with `$PATH`.
- https://github.com/jakehamilton/neovim/blob/c021f95a7ac55fab17784e94b9cf39a6302882b2/packages/neovim/lua/lspconfig.lua#L91
- https://github.com/jakehamilton/neovim/blob/c021f95a7ac55fab17784e94b9cf39a6302882b2/packages/neovim/lua/config.nix#L71

## Play with `hydra.nvim`
- https://github.com/anuvyklack/hydra.nvim

## Play with lsp status tools.
- https://github.com/arkav/lualine-lsp-progress
- https://github.com/nvim-lua/lsp-status.nvim

## Work in a base-16 theme with `mini-base16`:
- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-base16.md#features

## Get a modern lsp setup going.
- Look into nvim-cmp.
- Figure out what snippets are.
- Set up rust language server.

## DAP, and if it is a good value-add.
- https://github.com/mfussenegger/nvim-dap

## Create `lsp_lines` toggle shortcut.
So massive errors dont ruin readability.

```lua
vim.keymap.set(
  "",
  "<Leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)
```

- https://git.sr.ht/~whynothugo/lsp_lines.nvim

## Set up pandoc support.

## Set up better keyboard shortcuts.
- Look into whichkey https://github.com/folke/which-key.nvim
- Better buffer management.

Svimming in Neovim has some good ideas:
- https://github.com/yashsavani/Svimming-in-NeoVim#key-mappings

## Proper git support for diff3.
Look at youtube.
- Maybe: https://github.com/tpope/vim-fugitive

## Ctags support.
- https://ctags.io/

## Play with `:help index.txt`


# Handy links:
- https://github.com/rockerBOO/awesome-neovim
- https://github.com/nanotee/nvim-lua-guide
- https://github.com/mhinz/vim-galore
- https://github.com/folke/dot/blob/master/config/nvim/lua/config/options.lua
- https://github.com/AstroNvim/AstroNvim/blob/main/lua/core/mappings.lua
- https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/impatient.lua
