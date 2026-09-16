return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        local is_mac = vim.fn.has("macunix") == 1

        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_quickfix_mode = 0

        if is_mac then
            vim.g.vimtex_view_method = "skim"
            vim.g.vimtex_view_skim_sync = 1
            vim.g.vimtex_view_skim_activate = 1
        else
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = "SumatraPDF"
            vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
        end

        vim.g.vimtex_toc_config = {
            split_pos = "vert rightbelow",
            split_width = 30,
            show_help = 0,
        }
    end,
}