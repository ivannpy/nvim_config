-- Detección de plataforma compartida (macOS, WSL, Linux nativo)
local M = {}

M.is_mac = vim.fn.has("macunix") == 1
M.is_wsl = vim.fn.has("wsl") == 1 or vim.env.WSL_DISTRO_NAME ~= nil

-- Visor de PDF de Windows. Desde WSL se llama al .exe, convirtiendo las rutas
-- de Linux a Windows con wslpath (SumatraPDF no entiende rutas /home/...).
M.sumatra = "SumatraPDF"

if M.is_wsl then
    local exe = "/mnt/c/Program Files/SumatraPDF/SumatraPDF.exe"
    if vim.fn.executable("SumatraPDF") == 1 then
        -- Ya hay un wrapper en el PATH que convierte rutas
        M.sumatra = "SumatraPDF"
    elseif vim.fn.executable(exe) == 1 then
        local wrapper = vim.fn.stdpath("data") .. "/sumatra-wsl.sh"
        if vim.fn.filereadable(wrapper) == 0 then
            vim.fn.writefile({
                "#!/bin/bash",
                "args=()",
                'for a in "$@"; do',
                '  if [[ "$a" == /* && "$a" != /mnt/* ]]; then a="$(wslpath -w "$a")"; fi',
                '  args+=("$a")',
                "done",
                'exec "' .. exe .. '" "${args[@]}"',
            }, wrapper)
            vim.fn.setfperm(wrapper, "rwxr-xr-x")
        end
        M.sumatra = wrapper
    end
end

return M
