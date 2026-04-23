require("snacks").setup({
  notifier = { enabled = true, style = "compact" },
  indent = { enabled = true },
})

require("gitsigns").setup({
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
})

vim.g.barbar_auto_setup = false
require("barbar").setup({})

require("which-key").setup({
  delay = 800,
  preset = "helix",
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

require("tokyonight").setup({})
vim.cmd([[colorscheme tokyonight]])

require("lualine").setup()
