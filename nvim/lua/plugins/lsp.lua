return {
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    lazy = false,
    config = function()
      require("mason").setup({})
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    opts = {
      automatic_installation = true,
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "clangd",
          "docker_compose_language_service",
          "cssls",
          "diagnosticls",
          "eslint",
          "gopls",
          "graphql",
          "html",
          "jsonls",
          "lua_ls",
          "markdown_oxide",
          "nextls",
          "prismals",
          "pyright",
          "sqlls",
          "sqls",
          "tailwindcss",
          "terraformls",
          "ts_ls",
          "yamlls",

          -- Formatters
          "mdformat",
          "prettier",
          "stylua",
          "isort",
          "black",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      mason_lspconfig.setup_handlers({
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["graphql"] = function()
          -- configure graphql language server
          lspconfig["graphql"].setup({
            capabilities = capabilities,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
          })
        end,
        ["lua_ls"] = function()
          -- configure lua server (with special settings)
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                -- make the language server recognize "vim" global
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        end,
      })

      vim.keymap.set("n", "[c", vim.diagnostic.goto_prev, {}) -- jump to previous diagnostic in buffer
      vim.keymap.set("n", "]c", vim.diagnostic.goto_next, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {})
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {})
      vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
    end,
  },
}
