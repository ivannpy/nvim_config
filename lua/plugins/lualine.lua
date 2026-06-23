-- Pluging para agregar barra con status de Git
return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = ""
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                },
            },
        })
    end
}
