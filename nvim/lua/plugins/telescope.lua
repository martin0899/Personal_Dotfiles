return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar en contenido" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers abiertos" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "target", "node_modules", ".git" },
      },
    },
  },
  {
    "junegunn/fzf",
    build = function() vim.fn["fzf#install"]() end,
    lazy = false,
  },
  {
    "junegunn/fzf.vim",
    lazy = false,
    keys = {
      { "<leader>ff", "<cmd>FZF<cr>", desc = "Buscar archivo (FZF)" },
      { "<leader>fl", "<cmd>Line<cr>", desc = "Buscar línea" },
    },
  },
}
