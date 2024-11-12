return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = { render = "compact" },
    config = function()
      local notify = require("notify")

      vim.notify = notify
    end,
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
      },
      signcolumn = true,
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
    },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Buffer Management
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
    version = "^1.0.0",
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 800,
      preset = "helix",
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },
}
