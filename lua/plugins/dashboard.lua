-- Pantalla de inicio al abrir nvim sin argumentos
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        notifier = { enabled = true },
        picker = { enabled = true },
        explorer = { enabled = true, replace_netrw = true },
        dashboard = {
            preset = {
                header = table.concat({
                    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                }, "\n"),
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                    { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
        },
    },
}
