-- Formatear Rust al guardar con rustfmt (vía rust-analyzer, también ordena los imports)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function(args)
        vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
            filter = function(client)
                return client.name == "rust_analyzer"
            end,
        })
    end,
    desc = "Formatear Rust con rustfmt al guardar",
})
