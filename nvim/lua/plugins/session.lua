require("auto-session").setup({
  auto_save = true,
  auto_restore = true,
  -- Sessions stored in ~/.local/share/nvim/sessions/ (never pollutes cwd)
  suppressed_dirs = { "~/", "~/Downloads", "/" },
})
