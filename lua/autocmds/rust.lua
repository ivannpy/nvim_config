-- Organizar imports para Rust antes de guardar
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.code_action({
            context = {
                only = { "source.organizeImports" },
            },
            apply = true,
        })
    end,
})
