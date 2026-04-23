local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "mdformat" },
    graphql = { "prettier" },
    liquid = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 1000,
  },
})

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({
    lsp_format = "fallback",
    timeout_ms = 1000,
  })
end, { desc = "Format file or range (in visual mode)" })
