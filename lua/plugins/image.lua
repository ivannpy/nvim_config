return {
    "3rd/image.nvim",
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
