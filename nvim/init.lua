-- ============================
-- Setup of lazy.nvim
-- ============================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local g = vim.g

-- ============================
-- Leader/local leader configuration
-- ============================
g.mapleader = [[,]]
g.maplocalleader = [[,]]

-- ============================
-- Plugin initialization
-- ============================
require("lazy").setup("plugins")

-- ============================
-- Disable unwanted built-in plugins
-- ============================
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- ============================
-- General settings
-- ============================
local opt = vim.opt

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 20

-- Indent
opt.wrapmargin = 2
opt.textwidth = 80
opt.shiftround = true
opt.shiftwidth = 2
opt.expandtab = true

-- Mouse
opt.mousefocus = true
opt.mousemoveevent = true
opt.mousescroll = { "ver:1", "hor:6" }

-- Random
opt.clipboard = "unnamedplus"
opt.autoread = true
opt.hidden = true

-- views can only be fully collapsed with the global statusline
opt.laststatus = 3

-- Display
opt.wrap = true
opt.relativenumber = true
opt.cmdheight = 0
opt.showmode = false
opt.number = true
opt.linebreak = true -- lines wrap at words rather than random characters
opt.synmaxcol = 1024 -- don't syntax highlight long lines

-- List chars
opt.list = true -- invisible chars

-- Window splitting and buffers
-- do not use split or vsplit to ensure we don't open any new windows
opt.switchbuf = "useopen,uselast"
opt.inccommand = "split"
opt.fillchars = {
  fold = " ",
  eob = " ", -- suppress ~ at EndOfBuffer
  diff = "╱", -- alternatives = ⣿ ░ ─
  msgsep = " ", -- alternatives: ‾ ─
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}

-- Message output on vim actions
opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}

-- Match and search
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = false
opt.wrapscan = true -- Searches wrap around the end of the file
opt.scrolloff = 9
opt.sidescrolloff = 10
opt.sidescroll = 1

-- Colorscheme
opt.termguicolors = true
opt.background = "dark"

-- ============================
-- Keybindings
-- ============================
local silent = { silent = true, noremap = true }

-- Quit, close buffers, etc.
local map = vim.api.nvim_set_keymap
-- Move between buffers
map("n", "<C-z>", ":bp<CR>", silent)
map("n", "<C-x>", ":bn<CR>", silent)
map("n", "<C-c>", ":bd<CR>", silent)

-- Suspend session
map("n", "<C-H>", ":suspend<CR>", silent)

-- Remove highlight
map("n", "<Leader><space>", ":noh<cr>", silent)
