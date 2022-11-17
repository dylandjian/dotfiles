local packer = nil
local function init()
	if packer == nil then
		packer = require("packer")
		packer.init({})
	end

	local use = packer.use
	packer.reset()

	-- Packer
	use("wbthomason/packer.nvim")

	-- Improvement on loading time
	use("lewis6991/impatient.nvim")

	-- Improvement on exiting buffers ect
	use("mhinz/vim-sayonara")

	-- Better word motion
	use("chaoren/vim-wordmotion")

	-- Navigation
	use({
		"ggandor/leap.nvim",
		requires = "tpope/vim-repeat",
	})

	-- Indentation tracking
	use("lukas-reineke/indent-blankline.nvim")

	-- Commenting
	use({
		"numToStr/Comment.nvim",
	})

	-- Notifications
	use("rcarriga/nvim-notify")

	-- Git signs on buffers
	use({
		"lewis6991/gitsigns.nvim",
	})

	-- Search
	use("romainl/vim-cool")

	-- Add text objects
	use("wellle/targets.vim")

	-- Pretty symbols
	use("kyazdani42/nvim-web-devicons")

	-- Copy paste
	use("roxma/vim-tmux-clipboard")

	-- Files
	use({
		"ibhagwan/fzf-lua",
		-- optional for icon support
		requires = { "kyazdani42/nvim-web-devicons" },
		-- run = './install --bin',
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({
		"goolord/alpha-nvim",
	})

	use("folke/tokyonight.nvim")

	-- Bufferline
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "kyazdani42/nvim-web-devicons" })

	-- Highlights
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"RRethy/nvim-treesitter-textsubjects",
		},
		run = ":TSUpdate",
	})

	-- Completion
	use({ "neoclide/coc.nvim", branch = "release", run = ":CocUpdate" })
	use("rafcamlet/coc-nvim-lua")
end

local plugins = setmetatable({}, {
	__index = function(_, key)
		init()
		return packer[key]
	end,
})

return plugins
