-- Pluging para LSP
return {
    "neovim/nvim-lspconfig",       -- Gestor de Language Servers
    dependencies = {
        "mason-org/mason.nvim", -- Instalador de LSP
        "mason-org/mason-lspconfig.nvim"
    },
    config = function()
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "lua_ls",
                "pyright",
                "ruff",
                "texlab"
            },
        })
        -- Configuración para Rust
        vim.lsp.config("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    rustfmt = {
                        overrideCommand = {
                            "rustfmt",
                            "--edition",
                            "2021",
                        },
                    },
                }
            }
        })

        vim.lsp.enable("rust_analyzer")

        -- Configuración para Lua
        vim.lsp.config("lua_ls", {})

        vim.lsp.enable("lua_ls")

        -- Configuración para Python (PyRight: tipos, diagnotics y hover)
        vim.lsp.config("pyright", {
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })

        vim.lsp.enable("pyright")

        -- Configuración para formateador Python (ruff)
        vim.lsp.config("ruff", {
            init_options = {
                settings = {
                    organizeImports = true,
                },
            },
        })

        vim.lsp.enable("ruff")

        -- Evitar que Ruff pise el hover de Pyright (Ruff no debe manejar hover)
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then return end
                if client.name == "ruff" then
                    client.server_capabilities.hoverProvider = false
                end
            end,
            desc = "Desactivar hover de Ruff en favor de Pyright",
        })

        -- Formatear Python al guardar, usando explícitamente el cliente Ruff
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.py",
            callback = function(args)
                vim.lsp.buf.format({
                    bufnr = args.buf,
                    async = false,
                    filter = function(client)
                        return client.name == "ruff"
                    end,
                })
            end,
            desc = "Formatear Python con Ruff al guardar",
        })

        -- Configuración para latexmk
        local platform = require("core.platform")
        local is_mac = platform.is_mac
        local forward_search_config
        if is_mac then
            forward_search_config = {
                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            }
        else
            forward_search_config = {
                executable = platform.sumatra,
                args = { "-forward-search", "%f", "%l", "%p" },
            }
        end

        vim.lsp.config("texlab", {
            settings = {
                texlab = {
                    rootDirectory = nil,
                    build = {
                        executable = "latexmk",
                        args = {
                            "-pdf",
                            "-interaction=nonstopmode",
                            "-synctex=1",
                            "%f",
                        },
                        onSave = true, -- Compila automáticamente al guardar el archivo
                    },
                    forwardSearch = forward_search_config,
                    chktex = {
                        onEdit = false,
                        onOpenAndSave = false,
                    },
                },
            },
        })

        vim.lsp.enable("texlab")
    end
}
