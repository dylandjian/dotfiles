return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--glob",
              "!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}",
              "--path-separator",
              "/",
            },
          },
        },
      })
      -- telescope setup
      local builtin = require("telescope.builtin")

      vim.keymap.set(
        "n",
        "<C-p>",
        "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
        {}
      )

      vim.keymap.set("n", "\\", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>b", ":Telescope buffers<cr>", {})
      vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<cr>", {})

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("notify")
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
}
