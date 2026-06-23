-- Para copiar sin entorno gráfico usando OSC52
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = { "true" },
        ["*"] = { "true" },
    },
}
