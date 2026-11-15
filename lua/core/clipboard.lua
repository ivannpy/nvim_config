-- Configuración de portapapeles adaptativa:
--   • Local (macOS): pbcopy/pbpaste + 'unnamedplus' → copiar/pegar nativo del sistema.
--   • Local (Linux): xclip (X11), wl-copy (Wayland) o clip.exe (WSL) + 'unnamedplus'.
--   • Remoto (SSH sin GUI): OSC 52 solo permite *copiar* al portapapeles del cliente
--     (WezTerm lo soporta). No usamos 'unnamedplus', así 'p' pega del registro interno
--     '"' (siempre disponible tras 'y'). Pegar desde el portapapeles del cliente no es
--     posible en una sesión SSH estándar.
local ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil

if ssh then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = "",
            ["*"] = "",
        },
    }
else
    vim.opt.clipboard = "unnamedplus"

    local function executable(name)
        return vim.fn.executable(name) == 1
    end

    local copy_cmd, paste_cmd

    if vim.fn.has("mac") == 1 then
        copy_cmd = "pbcopy"
        paste_cmd = "pbpaste"
    elseif executable("win32yank.exe") then
        -- WSL: win32yank maneja UTF-8 y saltos de línea correctamente
        copy_cmd = { "win32yank.exe", "-i", "--crlf" }
        paste_cmd = { "win32yank.exe", "-o", "--lf" }
    elseif executable("powershell.exe") then
        -- WSL sin win32yank: clip.exe rompe el UTF-8, así que se usa PowerShell
        copy_cmd = {
            "powershell.exe",
            "-NoProfile",
            "-Command",
            "[Console]::InputEncoding=[Text.Encoding]::UTF8; Set-Clipboard -Value ([Console]::In.ReadToEnd())",
        }
        paste_cmd = {
            "powershell.exe",
            "-NoProfile",
            "-Command",
            "[Console]::OutputEncoding=[Text.Encoding]::UTF8; [Console]::Out.Write(((Get-Clipboard -Raw) -replace '\\r', ''))",
        }
    elseif vim.env.WAYLAND_DISPLAY and executable("wl-copy") then
        copy_cmd = { "wl-copy", "--type", "text/plain" }
        paste_cmd = { "wl-paste", "--no-newline" }
    elseif executable("xclip") then
        copy_cmd = { "xclip", "-selection", "clipboard" }
        paste_cmd = { "xclip", "-selection", "clipboard", "-o" }
    elseif executable("xsel") then
        copy_cmd = { "xsel", "--clipboard", "--input" }
        paste_cmd = { "xsel", "--clipboard", "--output" }
    else
        copy_cmd = ""
        paste_cmd = ""
    end

    vim.g.clipboard = {
        name = "auto",
        copy = {
            ["+"] = copy_cmd,
            ["*"] = copy_cmd,
        },
        paste = {
            ["+"] = paste_cmd,
            ["*"] = paste_cmd,
        },
    }
end
