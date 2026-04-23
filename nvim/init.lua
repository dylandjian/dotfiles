vim.g._start_time = vim.uv.hrtime()

-- Ensure nvm node bin is visible (needed for tree-sitter CLI, etc.)
if vim.env.NVM_BIN then
  vim.env.PATH = vim.env.NVM_BIN .. ":" .. vim.env.PATH
end

-- ============================
-- Leader/local leader configuration
-- ============================
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ============================
-- Build hooks (must come before vim.pack.add)
-- ============================
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local path = ev.data.path
    local kind = ev.data.kind

    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end

    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      vim.system(
        { "sh", "-c", "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release" },
        { cwd = path }
      )
    end
  end,
})

-- ============================
-- Plugin list
-- ============================
vim.pack.add({
  -- Core utilities
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MunifTanjim/nui.nvim",

  -- UI
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/romgrk/barbar.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/folke/snacks.nvim",

  -- Dashboard
  "https://github.com/goolord/alpha-nvim",

  -- Syntax highlighting
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

  -- LSP
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",

  -- Completion
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
  "https://github.com/onsails/lspkind.nvim",

  -- Formatting & linting
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",

  -- Navigation
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",

  -- Text editing
  "https://github.com/folke/flash.nvim",
  "https://github.com/chaoren/vim-wordmotion",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/windwp/nvim-autopairs",

  -- File tree
  "https://github.com/nvim-neo-tree/neo-tree.nvim",

  -- Session management (required for tmux-resurrect nvim restore)
  "https://github.com/rmagatti/auto-session",

  -- AI
  "https://github.com/coder/claudecode.nvim",
})

-- ============================
-- Load all opt plugins into runtimepath at startup
-- (vim.pack installs as opt by default; packadd makes them available)
-- ============================
local _plugins = {
  "plenary.nvim", "nvim-web-devicons", "nui.nvim",
  "gitsigns.nvim", "barbar.nvim",
  "which-key.nvim", "tokyonight.nvim", "lualine.nvim", "snacks.nvim",
  "alpha-nvim",
  "nvim-treesitter", "nvim-treesitter-textobjects",
  "mason.nvim", "mason-lspconfig.nvim", "mason-tool-installer.nvim", "nvim-lspconfig",
  "nvim-cmp", "cmp-buffer", "cmp-path", "cmp-nvim-lsp", "cmp-nvim-lsp-signature-help", "lspkind.nvim",
  "conform.nvim", "nvim-lint",
  "telescope.nvim", "telescope-fzf-native.nvim", "telescope-ui-select.nvim",
  "flash.nvim", "vim-wordmotion", "Comment.nvim", "nvim-surround", "nvim-autopairs",
  "neo-tree.nvim",
  "auto-session",
  "claudecode.nvim",
}
for _, name in ipairs(_plugins) do
  pcall(vim.cmd.packadd, name)
end

-- ============================
-- Disable unwanted built-in plugins
-- ============================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================
-- General settings
-- ============================
local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 20

opt.wrapmargin = 2
opt.textwidth = 80
opt.shiftround = true
opt.shiftwidth = 2
opt.expandtab = true

opt.mousefocus = true
opt.mousemoveevent = true
opt.mousescroll = { "ver:1", "hor:6" }

opt.clipboard = "unnamedplus"
opt.autoread = true
opt.hidden = true

opt.laststatus = 3

opt.wrap = true
opt.relativenumber = true
opt.cmdheight = 0
opt.showmode = false
opt.number = true
opt.linebreak = true
opt.synmaxcol = 1024

opt.list = true

opt.switchbuf = "useopen,uselast"
opt.inccommand = "split"
opt.fillchars = {
  fold = " ",
  eob = " ",
  diff = "╱",
  msgsep = " ",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}

opt.shortmess = {
  t = true,
  A = true,
  o = true,
  O = true,
  T = true,
  f = true,
  F = true,
  s = true,
  c = true,
  W = true,
}

opt.ignorecase = true
opt.smartcase = true
opt.smartindent = false
opt.wrapscan = true
opt.scrolloff = 9
opt.sidescrolloff = 10
opt.sidescroll = 1

opt.termguicolors = true
opt.background = "dark"

-- ============================
-- Load plugin configurations
-- ============================
require("plugins.ui")
require("plugins.session")
require("plugins.dashboard")
require("plugins.highlighting")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.formatting")
require("plugins.linting")
require("plugins.navigation")
require("plugins.text")
require("plugins.tree")
require("plugins.ai")

-- ============================
-- Keybindings
-- ============================
local silent = { silent = true, noremap = true }
local map = vim.api.nvim_set_keymap

map("n", "<C-z>", ":bp<CR>", silent)
map("n", "<C-x>", ":bn<CR>", silent)
map("n", "<C-c>", ":bd<CR>", silent)
map("n", "<C-H>", ":suspend<CR>", silent)
map("n", "<Leader><space>", ":noh<cr>", silent)

map("t", "<Esc>", [[<C-\><C-n>]], silent)
map("t", "<C-w>h", [[<C-\><C-n><C-w>h]], silent)
map("t", "<C-w>j", [[<C-\><C-n><C-w>j]], silent)
map("t", "<C-w>k", [[<C-\><C-n><C-w>k]], silent)
map("t", "<C-w>l", [[<C-\><C-n><C-w>l]], silent)
