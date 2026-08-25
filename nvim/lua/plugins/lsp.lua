return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- TypeScript / JavaScript (React)
      vim.lsp.config("ts_ls", { capabilities = capabilities })

      -- C / C++
      vim.lsp.config("clangd", { capabilities = capabilities })

      -- HTML
      vim.lsp.config("html", { capabilities = capabilities })

      -- CSS
      vim.lsp.config("cssls", { capabilities = capabilities })

      -- Habilitar todos los servidores
      vim.lsp.enable({ "ts_ls", "clangd", "html", "cssls" })
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      window = {
        normal_hl = "Comment",
        winblend = 100,
        border = "none",
        zindex = 45,
        max_width = 0,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = "bottom",
        relative = "editor",
        tabstop = 8,
        avoid = {},
      },
    },
  },
}
