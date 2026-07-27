-- Telescope
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, {
    desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
end, {
    desc = "Live grep",
})

vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, {
    desc = "Buffers",
})

-- Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem left<CR>", {
    silent = true,
    desc = "Toggle Neo-tree",
})

-- Formatear código
vim.keymap.set("n", "<leader>f", function()
    local ft = vim.bo.filetype

    if ft == "rust" then
        vim.cmd("write")

        local file_path = vim.fn.expand("%:p")
        local output = vim.fn.system(
            "rustfmt --edition 2021 " .. vim.fn.shellescape(file_path)
        )

        if vim.v.shell_error ~= 0 then
            print("Error en rustfmt: " .. output)
            return
        end

        vim.cmd("edit!")
        vim.notify("Formatted with rustfmt", vim.log.levels.INFO)
    
    elseif ft == "python" then
        vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
        vim.notify("Formatted with Ruff (LSP)", vim.log.levels.INFO)

    else
        vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
        vim.notify("Formatted via LSP", vim.log.levels.INFO)

    end
end, {
    desc = "Format code",
})

-- Folding
vim.keymap.set("n", "<leader>zo", "zO", {
    desc = "Open fold recursively",
})

vim.keymap.set("n", "<leader>z", "za", {
    desc = "Toggle fold",
})

vim.keymap.set("n", "<leader>zm", function()
    require("ufo").closeAllFolds()
end, {
    desc = "Close all folds",
})

vim.keymap.set("n", "<leader>zr", function()
    require("ufo").openAllFolds()
end, {
    desc = "Open all folds",
})

vim.keymap.set("n", "<leader>zz", function()
    require("ufo").closeAllFolds()
    vim.cmd("normal! zv")
end, {
    desc = "Focus fold at cursor",
})

vim.keymap.set("n", "<leader>zf", function()
    require("ufo").closeAllFolds()
    vim.cmd("normal! zO")
end, {
    desc = "Open fold at cursor",
})

-- LSP: Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
    desc = "Goto definition",
})

-- LSP: Go to uses (references) usando Telescope
vim.keymap.set("n", "gr", function()
    require("telescope.builtin").lsp_references()
end, {
    desc = "Goto references",
})

-- LSP: Code actions
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, {
    desc = "Code actions",
})

-- Refactoring
vim.keymap.set("n", "<leader>rf", function()
    require("refactoring").refactor("Extract Function")
end, {
    desc = "Extract Function",
})

vim.keymap.set("n", "<leader>rv", function()
    require("refactoring").refactor("Extract Variable")
end, {
    desc = "Extract Variable",
})

vim.keymap.set("n", "<leader>ri", function()
    require("refactoring").refactor("Inline Variable")
end, {
    desc = "Inline Variable",
})

vim.keymap.set("v", "<leader>rf", function()
    require("refactoring").refactor("Extract Function")
end, {
    desc = "Extract Function visual",
})

vim.keymap.set("v", "<leader>rv", function()
    require("refactoring").refactor("Extract Variable")
end, {
    desc = "Extract Variable visual",
})
