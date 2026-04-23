require("neo-tree").setup({
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
      hide_gitignored = false,
      hide_hidden = false,
      hide_by_name = {
        ".DS_Store",
      },
      always_show = {
        ".env",
      },
    },
  },
})

vim.keymap.set("n", "<Leader>t", ":Neotree toggle<CR>", { silent = true, noremap = true })
