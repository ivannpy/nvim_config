-- Pluging para autocompletado

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                -- Abrir menú de autocompletado
                ["<C-Space>"] = cmp.mapping.complete(),

                -- Enter. Aceptar primera sugerencia
                ["<CR>"] = cmp.mapping.confirm({
                    select = true,
                }),
            }),

            sources = {
                {
                    name = "nvim_lsp"
                },
                {
                    name = "buffer"
                },
            },
        })
    end
}
