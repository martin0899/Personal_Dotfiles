return {
  {
    "scrooloose/nerdtree",
    cmd = "NERDTreeCWD",
    keys = {
      { "<leader>t", "<cmd>NERDTreeCWD<cr>", desc = "Explorador de archivos" },
      { "<leader>h", "<cmd>NERDTreeFind<cr>", desc = "Buscar archivo en NERDTree" },
    },
    init = function()
      vim.g.NERDTreeQuitOnOpen = 1
      vim.g.NERDTreeChDirMode = 2
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype == "nerdtree" then
            vim.cmd("silent! normal R")
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if directory then
            local buf = vim.fn.bufnr("%")
            vim.cmd("NERDTreeCWD")
            vim.cmd("bdelete " .. buf)
          end
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nerdtree",
        callback = function()
          local function get_selected_path()
            local ok, result = pcall(vim.fn.eval, "NERDTreeFileNode.GetSelected().path.str()")
            if ok and type(result) == "string" and result ~= "" then
              return result
            end
            return nil
          end
          vim.keymap.set("n", "i", function()
            local filepath = get_selected_path()
            if filepath then
              vim.cmd("NERDTreeClose")
              vim.cmd("split")
              vim.cmd("edit " .. vim.fn.fnameescape(filepath))
              vim.cmd("wincmd =")
            end
          end, { buffer = true, noremap = true, silent = true })
          vim.keymap.set("n", "s", function()
            local filepath = get_selected_path()
            if filepath then
              vim.cmd("NERDTreeClose")
              vim.cmd("vsplit")
              vim.cmd("vertical resize 20")
              vim.cmd("edit " .. vim.fn.fnameescape(filepath))
            end
          end, { buffer = true, noremap = true, silent = true })
        end,
      })
    end,
  },
  {
    "easymotion/vim-easymotion",
    keys = {
      { "<leader>e", "<Plug>(easymotion-s2)", desc = "EasyMotion buscar" },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        },
        fast_wrap = {
          map = "<M-e>",
        },
      })
    end,
  },
}
