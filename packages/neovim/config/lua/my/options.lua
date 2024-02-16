-- Global Options
vim.opt.undofile = true        -- Persistent undo history
vim.opt.laststatus = 3         -- Always show the statusline
vim.opt.showmode = false       -- Hide the '-- INSERT --' prompt
vim.opt.magic = true           -- Use magic (similar to regex) in search
vim.opt.hlsearch = true        -- Highlight all matches
vim.opt.incsearch = true       -- Show incremental matches
vim.opt.inccommand = 'nosplit' -- Incremental live completion
vim.opt.hidden = true          -- Do not save when switching buffers
vim.opt.mouse = 'a'            -- Enable mouse mode
vim.opt.breakindent = true     -- Allow for cleanly wrapped indentation
vim.opt.ignorecase = true      -- By default ignore case on search
vim.opt.smartcase = true       -- Make search case sensitive on capital in search
vim.opt.updatetime = 250       -- Speed up update times for plugins
vim.opt.splitbelow = true      -- Vertical splits below the current window
vim.opt.splitright = true      -- Horizontal splits to the right of current window
vim.opt.title = true           -- Enable title
vim.opt.scrolloff = 7          -- Have 5 lines of padding at top & bottom
vim.opt.titlestring = [[%t%( %M%)%( (%{expand("%:~:.:h")})%)%( %a%)]]
vim.opt.listchars = "nbsp:_,tab:>-,trail:.,extends:>,precedes:<"
vim.opt.completeopt = "menuone,noselect"

-- Window Spessific
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative numbers
vim.opt.cursorline = true      -- Highlight current line
vim.opt.signcolumn= 'yes'      -- Always show the sign column

-- Buffer Spessific
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.shiftwidth = 4     -- Number of spaces to indicate a tab
vim.opt.tabstop = 4        -- Number of spaces to insert for tab
vim.opt.softtabstop = 4    -- Number of spaces for soft tabs
vim.opt.smartindent = true -- Make indenting smart

-- File Spessific
vim.cmd "autocmd FileType html setlocal ts=2 sw=2 sts=2"
vim.cmd "autocmd FileType lua setlocal ts=2 sw=2 sts=2"
vim.cmd "autocmd FileType nix setlocal ts=2 sw=2 sts=2"
vim.cmd "autocmd FileType javascript setlocal ts=2 sw=2 sts=2"
vim.cmd "autocmd FileType typescript setlocal ts=2 sw=2 sts=2"
vim.cmd "autocmd FileType c setlocal ts=2 sw=2 sts=2"

-- Other Options
vim.cmd "set iskeyword+=-"        -- Treat dash-seperated words as whole words
vim.cmd "command Show set list!"  -- Show hidden characters
