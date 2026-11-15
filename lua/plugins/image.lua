-- En WSL (Windows Terminal) no hay protocolo kitty: solo se carga si la terminal lo soporta
local platform = require("core.platform")
local kitty_terminal = vim.env.KITTY_WINDOW_ID ~= nil
    or vim.env.WEZTERM_EXECUTABLE ~= nil
    or vim.env.TERM_PROGRAM == "ghostty"
    or vim.env.TERM_PROGRAM == "WezTerm"

return {
    "3rd/image.nvim",
    cond = not platform.is_wsl or kitty_terminal,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        backend = "kitty",
        integrations = {
            markdown = {
                enabled = true,
            },
            neorg = {
                enabled = false,
            },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,
        hijack_file_patterns = {
            "*.png",
            "*.jpg",
            "*.jpeg",
            "*.gif",
            "*.webp",
        },
    },
}
