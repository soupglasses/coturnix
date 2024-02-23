local map = require("util").map

-- Set Up Leader Key
--
-- It is a good idea to set your leader key as early as possible in your
-- config, as any mappings created before you have set it will point to
-- the previous (default) leader.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Disable default actions for <Space>
map("n", "<Space>", "<Nop>")
map("v", "<Space>", "<Nop>")

-- Remap movement keys to deal with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Keep visual selection after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected line / block of text in visual mode
map("x", "<M-j>", ":move '>+1<CR>gv-gv")
map("x", "<M-k>", ":move '<-2<CR>gv-gv")
map("n", "<M-j>", ":move +<CR>==")
map("n", "<M-k>", ":move -2<CR>==")

-- Clear search with <Esc>
map("", "<Esc>", ":nohlsearch<Esc>")
map("n", "gw", "*N")
map("x", "gw", "*N")

-- Emacs-like sol and eol
map("n", "<C-e>", "$")
map("n", "<C-a>", "0")
map("i", "<C-e>", "<Esc>A")
map("i", "<C-a>", "<Esc>I")
map("i", "<M-f>", "<S-Right>")
map("i", "<M-b>", "<S-left>")
map("i", "<M-p>", "<Up>")
map("i", "<M-n>", "<Down>")

-- Make `Y` yank to the end of the line
map("n", "Y", "y$")

-- Move around splits using Ctrl + {h,j,k,l}
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Allow terminal mode to be exited with ESC
map("t", "<Esc>", "<C-\\><C-n>")

-- Diagnostic keybinds
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "[D]iagnostic [E]xpand" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.setloclist, { desc = "[D]iagnostic List" })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "[D]iagnostic [N]ext" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "[D]iagnostic [P]revious" })
