local opt = vim.opt

opt.number = true
opt.mouse = "a"
opt.numberwidth = 1
opt.clipboard = "unnamedplus"
opt.showcmd = true
opt.ruler = true
opt.cursorline = true
opt.encoding = "utf-8"
opt.showmatch = true
opt.shiftwidth = 2
opt.wrap = false
opt.laststatus = 2
opt.showmode = false

-- Spellcheck
opt.spell = true
opt.spelllang = "es"

-- Leader
vim.g.mapleader = " "

-- Gruvbox (se aplica en theme.lua después de cargar el plugin)
vim.g.gruvbox_contrast_dark = "hard"
