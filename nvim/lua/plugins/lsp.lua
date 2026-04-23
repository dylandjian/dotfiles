require("mason").setup({})

require("mason-tool-installer").setup({
  automatic_installation = true,
  ensure_installed = {
    "clangd",
    "docker_compose_language_service",
    "cssls",
    "eslint",
    "eslint_d",
    "gopls",
    "graphql",
    "html",
    "jsonls",
    "lua_ls",
    "markdown_oxide",
    "nextls",
    "prismals",
    "pylint",
    "pyright",
    "sqlls",
    "tailwindcss",
    "terraformls",
    "ts_ls",
    "yamlls",
    "mdformat",
    "prettier",
    "stylua",
    "isort",
    "black",
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
      })
    end,
    graphql = function()
      lspconfig.graphql.setup({
        capabilities = capabilities,
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      })
    end,
    lua_ls = function()
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })
    end,
  },
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = "if_many",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = true,
    border = "rounded",
  },
})

vim.keymap.set("n", "[c", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "]c", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {})
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {})
vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
