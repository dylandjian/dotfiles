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
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.relativenumber = true
opt.mouse = "a"
opt.number = true
opt.laststatus = 3
opt.cmdheight = 0
opt.inccommand = "split"
opt.smartindent = true
opt.autoread = true
opt.hidden = true
opt.shortmess = opt.shortmess + { c = true }
opt.updatetime = 300
opt.clipboard = "unnamed"

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
	"coc-json",
	"coc-prettier",
	"coc-tsserver",
	"coc-yaml",
	"coc-tslint",
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
map("i", "<c-space>", "coc#refresh()", silent)

-- Go to definition and other things
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

local packer_bootstrap = ensure_packer()
