-- Toggleterm.nvim - Terminal integrada
-- 2 terminales independientes: bash, jupyter
-- Todas cerradas al abrir nvim, se abren manualmente con keybindings
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 15,
            shade_filetypes = { "toggleterm" },
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            close_on_exit = false,
            shell = vim.o.shell,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        -- TERMINAL 1: Bash/Zsh General (horizontal split abajo - 1/4 altura)
        local bash_term = Terminal:new({
            id = 1,
            cmd = vim.o.shell,
            display_name = "Shell",
            direction = "horizontal",
            size = 15,
        })

        vim.api.nvim_create_user_command("ToggleTermShell", function()
            bash_term:toggle()
        end, { desc = "Toggle: Bash/Zsh terminal" })

        -- TERMINAL 2: Jupyter Notebook (flotante)
        local jupyter_term = Terminal:new({
            id = 2,
            cmd = "jupyter notebook",
            display_name = "Jupyter",
            direction = "float",
            close_on_exit = false,
        })

        vim.api.nvim_create_user_command("ToggleTermJupyter", function()
            if vim.env.VIRTUAL_ENV == nil then
                vim.notify("ADVERTENCIA: No hay venv activado. Activa uno antes de abrir nvim.", vim.log.levels.WARN)
            end
            jupyter_term:toggle()
        end, { desc = "Toggle: Jupyter Notebook" })
    end,
    keys = {
        { "<leader>tv", ":ToggleTermShell<CR>", desc = "Toggle: Shell Terminal" },
        { "<leader>tj", ":ToggleTermJupyter<CR>", desc = "Toggle: Jupyter Notebook" },
    }
}



