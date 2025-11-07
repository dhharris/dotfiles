return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    -- TODO: Make import more sane - require in dependencies here
    local mason_lspconfig = require("mason-lspconfig")

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = event.buf, silent = true }

        -- set keybinds
        opts.desc = "Go to declaration"
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        -- opts.desc = "Go to previous diagnostic"
        -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        -- opts.desc = "Go to next diagnostic"
        -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
      end, -- callback
    })

    vim.diagnostic.config({
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✗ ",
          [vim.diagnostic.severity.WARN]  = "⚠ ",
          [vim.diagnostic.severity.HINT]  = "➜ ",
          [vim.diagnostic.severity.INFO]  = "i ",
        },
      },
    })
  end,
}
