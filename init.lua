vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.o.foldmethod = "manual"
vim.o.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim"
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "rust_analyzer", "lua_ls" }
			})
			if vim.lsp.config then
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

				vim.lsp.config("lua_ls", {})
				vim.lsp.enable("lua_ls")
			else
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

	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", },
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-x>"] = cmp.mapping.complete(),
				}),
				sources = { { name = "nvim_lsp" }, { name = "buffer" }, { name = "cmp_ai" },}
			})
		end
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			require('onedark').setup {
				style = 'warmer'
			}
			require('onedark').load()
		end
	},

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

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end
	},

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

	{
		"tpope/vim-fugitive"
	},

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

	{
		"tzachar/cmp-ai",
		dependencies = "hrsh7th/nvim-cmp",
		config = function()
			local cmp_ai = require("cmp_ai.config")
			cmp_ai:setup({
				max_lines = 50,
				provider = "OpenAI",
				provider_options = {
					base_url = "https://openrouter.ai/api/v1/completions",
					model = "deepseek/deepseek-coder",
					api_key = os.getenv("OPENROUTER_API_KEY"),
					prompt = function(lines_before, lines_after)
						return lines_before
					end,
				},
				notify = true,
				notify_callback = function(msg)
					vim.notify(msg)
				end,
				run_on_every_keystroke = false,
				ignored_file_types = {},
			})
		end,
	},

})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem left<CR>", { silent = true })

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

vim.keymap.set("n", "<leader>zm", require("ufo").closeAllFolds)
vim.keymap.set("n", "<leader>zr", require("ufo").openAllFolds)
vim.keymap.set("n", "<leader>zo", "zO")
vim.keymap.set("n", "<leader>z", "za")
vim.keymap.set("n", "<leader>zz", function()
	require("ufo").closeAllFolds()
	vim.cmd("normal! zv")
end, { desc = "Focus fold at cursor" })

vim.keymap.set("n", "<leader>zf", function()
	require("ufo").closeAllFolds()
	vim.cmd("normal! zO")
end)

vim.keymap.set("n", "]e", vim.diagnostic.goto_next)
vim.keymap.set("n", "[e", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code actions" })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" } },
			apply = true
		})
	end
})
