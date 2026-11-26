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

-- Use vim.lsp.config (nvim 0.11+ native API) for servers that need custom settings.
-- lspconfig.setup() only updates the legacy lspconfig state, not vim.lsp.config.

-- terraform-ls uses init_options (not settings) — see:
-- https://github.com/hashicorp/terraform-ls/blob/main/docs/SETTINGS.md
-- indexing.ignorePaths prevents it from scanning the full git root on every file open,
-- which was causing nvim to appear frozen for 10–30s without the terraform CLI.
vim.lsp.config("terraformls", {
  init_options = {
    terraform = {
      timeout = "10s",
    },
    indexing = {
      ignorePaths = { ".git", ".terraform/providers" },
    },
  },
})

-- graphql: expand filetypes beyond the default
vim.lsp.config("graphql", {
  filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
})

-- lua_ls: teach it about the vim global
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      completion = { callSnippet = "Replace" },
    },
  },
})

-- terraform-ls sends invalid semantic token values (4294967295 = uint32 max)
-- which causes an infinite loop in Neovim's semantic_tokens.lua → 100% CPU freeze.
-- Workaround: strip semanticTokensProvider from the client on attach.
-- Bug: https://github.com/neovim/neovim/issues/36257
--      https://github.com/hashicorp/terraform-ls/issues/2094
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "terraformls" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- Apply cmp capabilities to every server that mason-lspconfig manages.
require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
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
