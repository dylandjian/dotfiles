require("nvim-treesitter").setup()

vim.schedule(function()
  require("nvim-treesitter.install").install({
    "c", "lua", "go", "python", "sql", "terraform", "tmux",
    "typescript", "javascript", "markdown", "markdown_inline", "vim",
  })
end)

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
