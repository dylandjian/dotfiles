return {
	-- Theme
	{ "folke/tokyonight.nvim" },

	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	-- Start-up screen
	{ "goolord/alpha-nvim" },

	-- Improvement on exiting buffers ect
	{ "mhinz/vim-sayonara" },

	-- Better word motion
	{ "chaoren/vim-wordmotion" },

	-- Navigation
	{
		"ggandor/leap.nvim",
		enabled = true,
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},

	-- Indentation tracking
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

	-- Commenting
	{
		"numToStr/Comment.nvim",
		config = true,
		keys = {
			{ "gc", mode = { "n", "v" }, desc = "Toggle comments" },
			{ "gb", mode = { "n", "v" }, desc = "Toggle block comments" },
		},
	},

	-- Notifications
	{ "rcarriga/nvim-notify", enabled = true },

	-- Git signs on buffers
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = {
					text = "+",
				},
				change = {
					text = "~",
				},
				delete = {
					text = "-",
				},
				topdelete = {
					text = "-",
				},
				changedelete = {
					text = "~",
				},
			},
			signcolumn = true, -- Toggle with `:GitSigns toggle_signs`
			watch_gitdir = { interval = 1000, follow_files = true },
			attach_to_untracked = true,
		},
	},

	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},

	-- Search
	{ "romainl/vim-cool", lazy = true, enable = false },

	-- Add text objects
	{ "wellle/targets.vim", lazy = true, enable = false },

	-- Pretty symbols
	{ "kyazdani42/nvim-web-devicons", lazy = true },

	-- Copy paste
	{ "roxma/vim-tmux-clipboard", lazy = true, enable = false },

	-- Files
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		enable = false,
	},

	-- Highlights
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"RRethy/nvim-treesitter-textsubjects",
		},
		build = ":TSUpdate",
	},

	-- Completion
	{ "neoclide/coc.nvim", branch = "release", build = ":CocUpdate" },
}
