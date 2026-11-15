-- Plugin para ver el markdown renderizado en el navegador
local platform = require("core.platform")

-- Para cambiar de navegador edita solo esta tabla (o define NVIM_MD_BROWSER).
-- Es el nombre de la aplicación: macOS usa `open -a`, Linux lo ejecuta como
-- programa y en WSL prueba primero Linux y luego `start` de Windows.
-- Ejemplos: "Google Chrome", "Firefox", "Safari" (mac); "chrome", "firefox" (wsl).
-- Con argumentos usa una lista: { "open", "-na", "Brave Browser", "--args", "--new-window" }
local browsers = {
    mac = "Brave Browser",
    wsl = "brave",
    linux = "brave-browser",
}

local function default_browser()
    if platform.is_mac then
        return browsers.mac
    elseif platform.is_wsl then
        return browsers.wsl
    end
    return browsers.linux
end

return {
    "sammaji/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    opts = {
        browser = vim.env.NVIM_MD_BROWSER or default_browser(),
    },
    keys = {
        { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown preview (navegador)" },
    },
}
