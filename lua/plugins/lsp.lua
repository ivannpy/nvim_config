-- Pluging para LSP
return {
    "neovim/nvim-lspconfig",       -- Gestor de Language Servers
    dependencies = {
        "williamboman/mason.nvim", -- Instalador de LSP
        "williamboman/mason-lspconfig.nvim"
    },
    config = function()
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "lua_ls",
                "pyright",
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

        -- Configuración para Python
        vim.lsp.config("pyright", {
            settings = {
                pyright = {
                    disableOrganizeImports = false,
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

        -- Configuración para latexmk
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
                    forwardSearch = {
                        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                        args = {
                            "--synctex-forward",
                            "%l:1:%f", "%p" },

                    },
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
