require("impatient")
vim.notify = require("notify")

local g = vim.g
local cmd = vim.cmd

-- Leader/local leader
g.mapleader = [[,]]
g.maplocalleader = [[,]]

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
	"gzip",
	"man",
	"matchit",
	"matchparen",
	"shada_plugin",
	"tarPlugin",
	"tar",
	"zipPlugin",
	"zip",
	"netrwPlugin",
}

for i = 1, 10 do
	g["loaded_" .. disabled_built_ins[i]] = 1
end

-- Settings
local opt = vim.opt

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 9

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

-- Display
opt.wrap = true
opt.relativenumber = true
opt.cmdheight = 0
opt.number = true
-- opt.linebreak = true -- lines wrap at words rather than random characters
-- opt.synmaxcol = 1024 -- don't syntax highlight long lines
opt.guifont = "FuraMono Nerd Font:h14,codicon"

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

-- Timings
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- Match and search
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true -- Searches wrap around the end of the file
opt.scrolloff = 9
opt.sidescrolloff = 10
opt.sidescroll = 1

-- Colorscheme
opt.termguicolors = true
opt.background = "dark"
cmd([[colorscheme tokyonight-storm]])

-- Commands
local create_cmd = vim.api.nvim_create_user_command
create_cmd("PackerInstall", function()
	cmd([[packadd packer.nvim]])
	require("plugins").install()
end, {})
create_cmd("PackerUpdate", function()
	cmd([[packadd packer.nvim]])
	require("plugins").update()
end, {})
create_cmd("PackerSync", function()
	cmd([[packadd packer.nvim]])
	require("plugins").sync()
end, {})
create_cmd("PackerClean", function()
	cmd([[packadd packer.nvim]])
	require("plugins").clean()
end, {})
create_cmd("PackerCompile", function()
	cmd([[packadd packer.nvim]])
	require("plugins").compile()
end, {})

-- Keybindings
local silent = { silent = true, noremap = true }

-- Quit, close buffers, etc.
local map = vim.api.nvim_set_keymap
map("n", "<C-z>", ":bp<CR>", silent)
map("n", "<C-x>", ":bn<CR>", silent)
map("n", "<C-c>", ":bd<CR>", silent)
map("n", "<Leader>r", ":CocCommand explorer <CR>", silent)
map("n", "<C-p>", ":FzfLua files<CR>", silent)
map("n", "<Leader>z", ":tabnew %<CR>", silent)
map("n", "\\", ":FzfLua grep<CR>", silent)
map("n", "<C-T>", ":FzfLua files", silent)
map("n", "<Leader>b", ":FzfLua buffers<CR>", silent)
map("n", "<Leader>s", ":BLines", silent)
map("n", "<C-H>", ":suspend<CR>", silent)
-- Hack because Ctrl-i = tab = completion
map("n", "<C-l>", "<C-i>", silent)
map("n", "<Leader><Leader>z", ":wq<CR>", silent)
map("n", "<Leader>o", ":ccl<CR>", silent)

-- CoC stuff
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.g.coc_global_extensions = {
	"coc-pyright",
	"coc-stylua",
	"coc-pairs",
	"coc-json",
	"coc-prettier",
	"coc-tsserver",
	"coc-yaml",
	"coc-explorer",
}

function _G.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

function _G.show_docs()
	local cw = vim.fn.expand("<cword>")
	if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command("h " .. cw)
	elseif vim.api.nvim_eval("coc#rpc#ready()") then
		vim.fn.CocActionAsync("doHover")
	else
		vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
	end
end

-- Go to definition and other things
map("i", "<c-space>", "coc#refresh()", { expr = true })
map("n", "<Leader>qf", "<Plug>(coc-fix-current)", silent)
map("n", "K", "<CMD>lua _G.show_docs()<CR>", silent)
map("n", "<c-k>", "<Plug>(coc-rename)", silent)
map("n", "[g", "<Plug>(coc-diagnostic-prev)", silent)
map("n", "]g", "<Plug>(coc-diagnostic-next)", silent)
map("n", "gd", "<Plug>(coc-definition)", silent)
map("n", "gy", "<Plug>(coc-type-definition)", silent)
map("n", "gi", "<Plug>(coc-implementation)", silent)
map("n", "gr", "<Plug>(coc-references)", silent)

local opts = { silent = true, noremap = true, expr = true }
map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

ensure_packer()
