-- Tecla lider para atajos
vim.g.mapleader = " "
-- Mostrar número de línea
vim.opt.number = true
-- Mostrar número relativo
vim.opt.relativenumber = true
-- identación
vim.opt.shiftwidth = 4
-- Tab = 4 espacios
vim.opt.tabstop = 4

--Mostrar columna para controlar folding
vim.o.foldcolumn = "1"
-- Profundidad del folding
vim.opt.foldlevel = 99
-- Abre todo al inicio
vim.opt.foldlevelstart = 99

-- Usar clipboard del sistema
vim.opt.clipboard = "unnamedplus"

-- Instalación de LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Plugin para tema Tokyo Night
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 100,
		opts = {
			style = "night"
		},
	},

	-- Pluging para parser avanzado: resaltado, identación, navegación.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local status, configs = pcall(require, "nvim-treesitter.configs")
			if not status then return end

			configs.setup({
				ensure_installed = { "rust", "lua", "bash" },
				highlight = { enable = true },
			})
		end
	},

	-- Pluging para LSP
	{
		"neovim/nvim-lspconfig", -- Gestor de Language Servers
		dependencies = {
			"williamboman/mason.nvim", -- Instalador de LSP
			"williamboman/mason-lspconfig.nvim"
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "rust_analyzer", "lua_ls" }
			})
			if vim.lsp.config then -- Neovim 0.8+
				-- Configuración para Rust
				vim.lsp.config("rust_analyzer", {
					settings = {
						["rust-analyzer"] = {
							rustfmt = {
								overrideCommand = { "rustfmt", "--edition", "2021" },
							},
						}
					}
				})
				vim.lsp.enable("rust_analyzer")

				-- Configuración para Lua
				vim.lsp.config("lua_ls", {})
				vim.lsp.enable("lua_ls")
			else -- Neovim < 0.8
				local lspconfig = require("lspconfig")
				lspconfig.rust_analyzer.setup({
					settings = {
						["rust-analyzer"] = {
							rustfmt = { overrideCommand = { "rustfmt", "--edition", "2021" } },
						}
					}
				})
				lspconfig.lua_ls.setup({})
			end
		end
	},

	-- Pluging para autocompletado
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", },
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					-- Abrir menú de autocompletado
					["<C-Space>"] = cmp.mapping.complete(),
					-- Enter. Aceptar primera sugerencia
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = { { name = "nvim_lsp" }, { name = "buffer" }, }
			})
		end
	},

	-- Pluging para abrir browser/tree de archivos
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }
	},

	-- Pluging para buscar archivos o en archivos.
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	-- Pluging para autocerrar {}, (), "", ''
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")

			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done()
			)
		end
	},

	-- Pluging para visualizar cambios de Git
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end
	},

	-- Pluging para agregar barra con status de Git
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					section_separators = "",
					component_separators = ""
				},
				sections = {
					lualine_b = { "branch", "diff", "diagnostics" }
				}
			})
		end
	},

	-- Pluging para usar comandos Git
	{
		"tpope/vim-fugitive"
	},

	-- Pluging para folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("ufo").setup({
				provider_selector = function()
					return { "treesitter", "indent" }
				end
			})
		end
	},

	-- Pluging para mostrar ayuda sobre comandos
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	-- Pluging para mostrar autor, resumen, fecha de commits
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		opts = {
			enabled = true,
			message_template = " <summary> • <date> • <author> • <<sha>>",
			date_format = "%m-%d-%Y %H:%M:%S",
			virtual_text_column = 1,
		},

	},

	-- Pluging para refactorizar
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup()
		end
	},

	-- Pluging para guías visuales de identación
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
				},
				scope = {
					char = "│",
					show_start = true,
					show_end = true,
				},
				exclude = {
					filetypes = {
						"help",
						"startify",
						"dashboard",
						"neo-tree",
						"Trouble",
						"lazy",
						"alpha",
						"lspinfo",
						"checkhealth",
						"toggleterm",
						"DressingInput",
					},
					buftypes = {
						"terminal",
						"nofile",
					},
				},
			})
		end
	},

	-- Pluging para resaltar problemas
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

})

-- Tema por defecto

vim.cmd("colorscheme tokyonight")

-- Configuración de Telescope

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

-- Configuración de NeoTree

vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem left<CR>", { silent = true })

-- Configuración para dar formato

vim.keymap.set("n", "<leader>f", function()
	if vim.bo.filetype == "rust" then
		vim.cmd("write")

		local file_path = vim.fn.expand("%:p")
		local output = vim.fn.system("rustfmt --edition 2021 " .. vim.fn.shellescape(file_path))

		if vim.v.shell_error ~= 0 then
			print("Error en rustfmt: " .. output)
			return
		end

		vim.cmd("edit!")
	else
		vim.lsp.buf.format({ async = true })
	end
end, { desc = "Format code with system rustfmt" })

-- Configuración del folding

vim.keymap.set("n", "<leader>zo", "zO")
vim.keymap.set("n", "<leader>z", "za")

vim.keymap.set("n", "<leader>zm", require("ufo").closeAllFolds)
vim.keymap.set("n", "<leader>zr", require("ufo").openAllFolds)
vim.keymap.set("n", "<leader>zz", function()
	require("ufo").closeAllFolds()
	vim.cmd("normal! zv")
end, { desc = "Focus fold at cursor" })
vim.keymap.set("n", "<leader>zf", function()
	require("ufo").closeAllFolds()
	vim.cmd("normal! zO")
end)

-- Configuración del LSP

-- Go to def
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })

-- Abre acciones disponibles del LSP
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Organizar y limpiar imports para Rust luego de escribir
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" } },
			apply = true
		})
	end
})

-- Configuración para refactoring
vim.keymap.set("n", "<leader>rf", function()
	require("refactoring").refactor("Extract Function")
end, { desc = "Extract Function" })

vim.keymap.set("n", "<leader>rv", function()
	require("refactoring").refactor("Extract Variable")
end, { desc = "Extract Variable" })

vim.keymap.set("n", "<leader>ri", function()
	require("refactoring").refactor("Inline Variable")
end, { desc = "Inline Variable" })

vim.keymap.set("v", "<leader>rf", function()
	require("refactoring").refactor("Extract Function")
end, { desc = "Extract Function (visual)" })

vim.keymap.set("v", "<leader>rv", function()
	require("refactoring").refactor("Extract Variable")
end, { desc = "Extract Variable (visual)" })

-- Colores para guías de identación
vim.cmd([[
    highlight IndentBlanklineChar guifg=#333333 gui=nocombine
    highlight IndentBlanklineContextChar guifg=#555555 gui=nocombine
]])
