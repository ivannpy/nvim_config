-- Al abrir nvim sin argumentos, muestra el explorer a la izquierda y el dashboard al centro
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() > 0 or vim.g.started_with_stdin then
            return
        end
        vim.schedule(function()
            vim.cmd("Neotree show filesystem left")
        end)
    end,
})

vim.api.nvim_create_autocmd("StdinReadPre", {
    callback = function()
        vim.g.started_with_stdin = true
    end,
})
