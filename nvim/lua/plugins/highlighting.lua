require("nvim-treesitter").setup()

-- Install parsers using the public API (new nvim-treesitter rewrite for nvim 0.12+)
vim.schedule(function()
  require("nvim-treesitter").install({
    "c", "lua", "go", "python", "sql", "terraform", "tmux",
    "typescript", "javascript", "markdown", "markdown_inline", "vim",
  })
end)

-- Enable treesitter highlighting + per-buffer folds for supported filetypes.
-- The new nvim-treesitter rewrite does NOT auto-enable features; we must opt in.
local ts_filetypes = {
  "c", "lua", "go", "python", "sql", "terraform", "tmux",
  "typescript", "javascript", "typescriptreact", "javascriptreact",
  "markdown", "vim",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function()
    vim.treesitter.start()
    -- Scope folds to buffers that actually have a treesitter parser instead of globally
    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldlevel = 20
  end,
})

local ts_select = require("nvim-treesitter-textobjects.select")
local select_maps = {
  af = { "@function.outer", "textobjects" },
  ["if"] = { "@function.inner", "textobjects" },
  ac = { "@class.outer", "textobjects" },
  ic = { "@class.inner", "textobjects" },
  as = { "@local.scope", "locals" },
}
for key, args in pairs(select_maps) do
  vim.keymap.set({ "x", "o" }, key, function()
    ts_select.select_textobject(args[1], args[2])
  end)
end
