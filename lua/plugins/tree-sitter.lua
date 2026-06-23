-- Pluging para parser avanzado: resaltado, identación, navegación.

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local status, configs = pcall(require, "nvim-treesitter.configs")
        if not status then return end

        configs.setup({
            ensure_installed = {
                "rust",
                "lua",
                "bash",
                "python" },
            highlight = {
                enable = true
            },
        })
    end,
}
