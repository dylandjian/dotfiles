return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    init = function()
      -- ============================
      -- Use NeoTree instead of netrw
      -- ============================
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
        callback = function()
          local f = vim.fn.expand("%:p")
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd("Neotree current dir=" .. f)
            vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
          end
        end,
      })
    end,
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.keymap.set("n", "<Leader>t", ":Neotree toggle<CR>", silent)
    end,
    opts = {
      close_if_last_window = true,
      window = {
        mappings = {
          ["<space>"] = { "toggle_node", nowait = true },
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            ".DS_Store",
          },
          always_show = {
            ".env",
          },
        },
      },
    },
  },
}
