-- Pluging para trabajar con latex
return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_quickfix_mode = 0

        -- Sincronización con Skim via neovim-remote
        vim.g.vimtex_view_skim_sync = 1       -- SyncTeX forward search al compilar
        vim.g.vimtex_view_skim_activate = 1   -- Skim pasa a primer plano al abri

        -- Sincronización con Skim via neovim-remote
        vim.g.vimtex_view_skim_sync = 1       -- SyncTeX forward search al compilar
        vim.g.vimtex_view_skim_activate = 1   -- Skim pasa a primer plano al abrirr

        vim.g.vimtex_toc_config = {
            split_pos = "vert rightbelow",
            split_width = 30,
            show_help = 0,
        }
    end,
}
