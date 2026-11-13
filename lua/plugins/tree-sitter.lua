-- Pluging para parser avanzado: resaltado, identación, navegación.
-- Rama main: instala parsers/queries; el resaltado lo activa Neovim.

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- Parsers a instalar (no hace nada si ya están instalados)
        require("nvim-treesitter").install({
            "rust",
            "lua",
            "bash",
            "python",
            "markdown",
            "markdown_inline",
            "json",
            "toml",
            "yaml",
        })

        -- Filetypes con resaltado de treesitter
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "rust", "lua", "sh", "bash", "python", "markdown", "json", "toml", "yaml" },
            callback = function(args)
                -- Falla sin error si el parser aún no está instalado
                if not pcall(vim.treesitter.start, args.buf) then
                    return
                end

                -- Identación con treesitter (experimental), markdown no tiene queries
                if vim.bo[args.buf].filetype ~= "markdown" then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
