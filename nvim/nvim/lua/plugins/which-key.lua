return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    delay = 500,
  },
  config = function()
    local wk = require("which-key")
    wk.setup({
      preset = "modern",
      plugins = { spelling = true },
      delay = 200,
      icons = {
        mappings = false,
        breadcrumb = "",
        separator = " ",
        group = "",
      },
      win = {
        border = "rounded",
        padding = { 1, 1, 1, 1 },
        height = { min = 4, max = 10 },
        width = { min = 20, max = 250 },
      },
      layout = {
        height = { min = 4, max = 10 },
        width = { min = 20, max = 250 },
        spacing = 2,
        align = "left",
      },
      sort = { "local", "order", "group", "alphanum", "mod" },
    })

    wk.add({
      { "<leader>f", group = "Buscar" },
      { "<leader>ft", desc = "Archivos (:Telescope find_files)" },
      { "<leader>fg", desc = "En contenido (:Telescope live_grep)" },
      { "<leader>fb", desc = "Buffers abiertos (:Telescope buffers)" },
      { "<leader>ff", desc = "Archivo (:FZF)" },
      { "<leader>fl", desc = "Línea (:Line)" },

      { "<leader>t", group = "NERDTree" },
      { "<leader>h", desc = "Buscar archivo en NERDTree" },

      { "<leader>g", group = "Goto Preview" },
      { "<leader>gd", desc = "Definición (goto_preview_definition)" },
      { "<leader>gD", desc = "Declaración (goto_preview_declaration)" },
      { "<leader>gi", desc = "Implementación (goto_preview_implementation)" },
      { "<leader>gy", desc = "Tipo (goto_preview_type_definition)" },
      { "<leader>gr", desc = "Referencias (goto_preview_references)" },
      { "<leader>gp", desc = "Cerrar vistas (close_all_win)" },

      { "<leader>d", group = "Diagnósticos" },
      { "<leader>dn", desc = "Siguiente error (vim.diagnostic.goto_next)" },
      { "<leader>dp", desc = "Error anterior (vim.diagnostic.goto_prev)" },
      { "<leader>df", desc = "Flotante errores (vim.diagnostic.open_float)" },
      { "<leader>dl", desc = "Enviar a loclist (vim.diagnostic.setloclist)" },

      { "<leader>r", group = "Redimensionar" },
      { "<leader>rh", desc = "Más angosta ← (Ctrl-w 20 <)" },
      { "<leader>rl", desc = "Más ancha → (Ctrl-w 20 >)" },
      { "<leader>rj", desc = "Más alta ↑ (Ctrl-w 20 +)" },
      { "<leader>rk", desc = "Más baja ↓ (Ctrl-w 20 -)" },
      { "<leader>re", desc = "Igualar tamaño (Ctrl-w =)" },

      { "<leader>c", group = "Comentar" },
      { "<leader>cc", desc = "Toggle línea/bloque" },
      { "<leader>cq", desc = "Comentar bloque" },
      { "<leader>ca", desc = "Comentar arriba" },
      { "<leader>cb", desc = "Comentar abajo" },
      { "<leader>ce", desc = "Comentar final de línea" },

      { "<leader>n", group = "Proyectos" },
      { "<leader>np", desc = "Crear proyecto (project-templates)" },

      { "<leader>lg", desc = "LazyGit (terminal)" },

      { "<leader>a", group = "AI" },
      { "<leader>ao", desc = "OpenCode (terminal)" },
      { "<leader>am", desc = "Mimo (terminal)" },

      { "<leader>w", desc = "Guardar archivo (:w!)" },
      { "<leader>q", desc = "Cerrar ventana (:q)" },
      { "<leader>s", desc = "Guardar y cerrar (:wq)" },
      { "<leader>x", desc = "Cerrar sin guardar (:q!)" },
      { "<leader>e", desc = "EasyMotion (saltar 2 chars)" },

      { "<leader>b", group = "Buffer" },
      { "<leader>bd", desc = "Cerrar buffer (:bdelete!)" },
      { "<leader>bp", desc = "Fijar/desfijar buffer" },
      { "<leader>bo", desc = "Cerrar otros buffers" },
      { "<leader>br", desc = "Cerrar buffers derecha" },
      { "<leader>bl", desc = "Cerrar buffers izquierda" },

      -- Visual mode: Text Objects
      { "v", group = "  Visual", mode = "v" },
      { "i(", desc = "Dentro de ()", mode = "v" },
      { "i{", desc = "Dentro de {}", mode = "v" },
      { "i[", desc = "Dentro de []", mode = "v" },
      { "i<", desc = "Dentro de <>", mode = "v" },
      { "it", desc = "Dentro de tag HTML", mode = "v" },
      { "a(", desc = "Alrededor de ()", mode = "v" },
      { "a{", desc = "Alrededor de {}", mode = "v" },
      { "a[", desc = "Alrededor de []", mode = "v" },
      { "a<", desc = "Alrededor de <>", mode = "v" },
      { "at", desc = "Alrededor de tag HTML", mode = "v" },
    })
  end,
}
