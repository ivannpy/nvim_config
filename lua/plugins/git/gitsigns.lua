-- Pluging para mostrar cambios de git en neovim

return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end
}
