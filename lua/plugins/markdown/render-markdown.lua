-- Plugin para renderizar markdown dentro de nvim
return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    keys = {
        { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle render markdown" },
    },
}
