-- Configuración de portapapeles adaptativa:
--   • Local (macOS): pbcopy/pbpaste + 'unnamedplus' → copiar/pegar nativo del sistema.
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
    vim.g.clipboard = {
        name = "macOS-clipboard",
        copy = {
            ["+"] = "pbcopy",
            ["*"] = "pbcopy",
        },
        paste = {
            ["+"] = "pbpaste",
            ["*"] = "pbpaste",
        },
    }
end
