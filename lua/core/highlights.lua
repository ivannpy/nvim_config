local function set_highlights()
    vim.api.nvim_set_hl(0, "IndentBlanklineChar", {
        fg = "#333333",
        nocombine = true,
    })

    vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", {
        fg = "#555555",
        nocombine = true,
    })
end

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_highlights,
})


