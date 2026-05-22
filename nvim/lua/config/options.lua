local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
-- Colorscheme is set in ~/.config/nvim/lua/plugins/tokyonight.lua

-- Scrolling
opt.scrolloff = 8

-- Clipboard
opt.clipboard = "unnamedplus"

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Mouse support
opt.mouse = "a"

-- Undo history
opt.undofile = true
