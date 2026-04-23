local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = { prompt_position = "top" },
    },
    path_display = { "truncate" },
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "%.lock",
      "dist/",
      "build/",
      "target/",
      "%.min.js",
      "Pods/",
      "DerivedData/",
    },
    cache_picker = {
      num_pickers = 10,
    },
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
    find_files = {
      hidden = true,
    },
    live_grep = {
      additional_args = { "--hidden" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "\\", builtin.live_grep, {})
vim.keymap.set("n", "<leader>b", ":Telescope buffers<cr>", {})
vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<cr>", {})
vim.keymap.set("n", "<leader>p", ":Telescope resume<cr>", {})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
