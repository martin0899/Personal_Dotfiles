return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
      dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
      dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
      dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
    }

    -- Disable folding on alpha buffer
    vim.cmd([[
      autocmd FileType alpha setlocal nofoldenable
    ]])

    local function get_hl(group, prop)
      local hl = vim.api.nvim_get_hl(0, { name = group })
      return hl[prop] and string.format("#%06x", hl[prop]) or nil
    end

    local function fallback(val, default)
      return val or default
    end

    local header_fg = fallback(get_hl("Directory", "fg"), "#458588")
    local button_fg = fallback(get_hl("Normal", "fg"), "#ebdbb2")
    local shortcut_fg = fallback(get_hl("WarningMsg", "fg"), "#d65d0e")
    local footer_fg = fallback(get_hl("Comment", "fg"), "#a89984")

    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = header_fg, bold = true })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = button_fg })
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = shortcut_fg, bold = true })
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = footer_fg })

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- Send config to alpha
    alpha.setup(dashboard.opts)
  end,
}
