-- Edita Markdown en Neovim y lo ve renderizado en MarkEdit
return {
    "ivannpy/MarkEdit.nvim",
    -- para desarrollar en local: dir = "~/developer/markedit.nvim",
    ft = "markdown",
    cmd = { "MarkEditOpen", "MarkEditClose", "MarkEditToggle", "MarkEditStatus", "MarkEditLog" },
    opts = {},
    keys = {
        { "<leader>mp", "<cmd>MarkEditToggle<cr>", ft = "markdown", desc = "Markdown en MarkEdit" },
    },
}
