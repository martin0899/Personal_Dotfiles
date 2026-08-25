local map = vim.keymap.set

-- Guardar / Salir
map("n", "<Leader>q", ":q<CR>", { desc = "Cerrar ventana" })
map("n", "<Leader>w", ":w!<CR>", { desc = "Guardar archivo" })
map("n", "<Leader>s", ":wq<CR>", { desc = "Guardar y salir" })
map("n", "<Leader>x", ":q!<CR>", { desc = "Forzar cerrar", noremap = true, silent = true })

-- Navegación entre ventanas (Normal)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Navegación entre ventanas (Terminal - sale de terminal mode primero)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Ventana izquierda" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Ventana derecha" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Ventana inferior" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Ventana superior" })

-- Redimensionar ventanas con <Leader>r + h/j/k/l
map("n", "<Leader>rh", "<C-w>20<", { desc = "Reducir ancho" })
map("n", "<Leader>rl", "<C-w>20>", { desc = "Aumentar ancho" })
map("n", "<Leader>rj", "<C-w>20+", { desc = "Aumentar alto" })
map("n", "<Leader>rk", "<C-w>20-", { desc = "Reducir alto" })
map("n", "<Leader>re", "<C-w>=", { desc = "Igualar tamaño de todos" })

-- Herramientas AI
map("n", "<Leader>ao", ":botright split | terminal opencode<CR>", { desc = "Abrir OpenCode", noremap = true, silent = true })
map("n", "<Leader>am", ":botright split | terminal mimo<CR>", { desc = "Abrir Mimo", noremap = true, silent = true })

-- LazyGit
map("n", "<Leader>lg", ":botright split | terminal lazygit<CR>", { desc = "Abrir LazyGit", noremap = true, silent = true })

-- Diagnósticos (errores del LSP) - <Leader>d
map("n", "<Leader>dn", function() vim.diagnostic.goto_next() end, { desc = "Siguiente error" })
map("n", "<Leader>dp", function() vim.diagnostic.goto_prev() end, { desc = "Error anterior" })
map("n", "<Leader>df", function() vim.diagnostic.open_float() end, { desc = "Ver errores en ventana flotante" })
map("n", "<Leader>dl", function() vim.diagnostic.setloclist() end, { desc = "Enviar errores a loclist" })

-- Plantillas de proyecto
map("n", "<Leader>np", function() require("project-templates").create_project() end, { desc = "Crear nuevo proyecto" })
