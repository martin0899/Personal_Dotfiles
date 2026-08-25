return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      toggler = {
        line = "<Leader>cc",
        block = "<Leader>cc",
      },
      opleader = {
        line = "<Leader>c",
        block = "<Leader>cq",
      },
      extra = {
        above = "<Leader>ca",
        below = "<Leader>cb",
        eol = "<Leader>ce",
      },
      mappings = {
        basic = true,
        extra = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "● ",
        close_icon = " ",
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 20,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "NERDTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Siguiente buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer anterior" },
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Siguiente buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer anterior" },
      { "<S-d>", "<cmd>bdelete!<CR>", desc = "Cerrar buffer actual" },
      { "<leader>bd", "<cmd>bdelete!<CR>", desc = "Cerrar buffer actual" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Fijar buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Cerrar otros buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Cerrar buffers a la derecha" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Cerrar buffers a la izquierda" },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smear_cursor").setup()
    end,
  },
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    config = function()
      require("goto-preview").setup({
        default_mappings = false,
        height = 15,
        width = 120,
      })

      local map = vim.keymap.set
      map("n", "<leader>gd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { desc = "Preview definición" })
      map("n", "<leader>gD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", { desc = "Preview declaración" })
      map("n", "<leader>gi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", { desc = "Preview implementación" })
      map("n", "<leader>gy", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", { desc = "Preview tipo" })
      map("n", "<leader>gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { desc = "Preview referencias" })
      map("n", "<leader>gp", "<cmd>lua require('goto-preview').close_all_win()<CR>", { desc = "Cerrar previews" })
    end,
  },
  {
    "rmagatti/logger.nvim",
    event = "VeryLazy",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    config = function()
      require("render-markdown").setup({
        heading = {
          enabled = true,
          sign = true,
          style = "full",
          icons = { "① ", "② ", "③ ", "④ ", "⑤ ", "⑥ " },
          left_pad = 1,
        },
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
          right_pad = 1,
          highlight = "render-markdownBullet",
        },
        checkbox = {
          enabled = true,
          unchecked = {
            icon = "󰄱     ",
            highlight = "RenderMarkdownUnchecked",
          },
          checked = {
            icon = "󰱒     ",
            highlight = "RenderMarkdownChecked",
          },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔     ", highlight = "RenderMarkdownTodo" },
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+,? %d+%)",
          group = function(_, match)
            local h, s, l = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
            h, s, l = tonumber(h), tonumber(s), tonumber(l)
            local function hsl_to_hex(hi, si, li)
              si = si / 100
              li = li / 100
              local c = (1 - math.abs(2 * li - 1)) * si
              local x = c * (1 - math.abs((hi / 60) % 2 - 1))
              local m = li - c / 2
              local r, g, b = 0, 0, 0
              if hi < 60 then r, g, b = c, x, 0
              elseif hi < 120 then r, g, b = x, c, 0
              elseif hi < 180 then r, g, b = 0, c, x
              elseif hi < 240 then r, g, b = 0, x, c
              elseif hi < 300 then r, g, b = x, 0, c
              else r, g, b = c, 0, x end
              return string.format("#%02x%02x%02x",
                math.floor((r + m) * 255),
                math.floor((g + m) * 255),
                math.floor((b + m) * 255))
            end
            local hex = hsl_to_hex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex, "bg")
          end,
        },
      },
    },
  },
}
