-- Tecla lider para atajos
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH

require("core.options")
require("core.clipboard")

require("config.lazy")

require("core.highlights")
require("core.keymaps")

require("autocmds")
