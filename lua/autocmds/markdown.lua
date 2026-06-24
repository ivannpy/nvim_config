local md_pdf_group = vim.api.nvim_create_augroup("MarkdownPDF", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = md_pdf_group,
  pattern = "*.md",
  callback = function()
    local input = vim.fn.expand("%:p")         -- ruta absoluta del .md
    local output = vim.fn.expand("%:p:r") .. ".pdf"  -- mismo nombre, extensión .pdf

    -- Compilar con pandoc en background
    vim.fn.jobstart({
      "pandoc",
      input,
      "--pdf-engine=pdflatex",
      "--mathjax",              -- fórmulas LaTeX correctas
      "-V", "geometry:margin=2cm",
      "-o", output,
    }, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("PDF actualizado ✓", vim.log.levels.INFO)

          -- Abrir en Skim si no está abierto aún
          vim.fn.jobstart({ "open", "-a", "Skim", output })
        else
          vim.notify("Error al compilar PDF ✗", vim.log.levels.ERROR)
        end
      end,
    })
  end,
})
