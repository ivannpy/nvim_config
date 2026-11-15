local platform = require("core.platform")
local is_mac = platform.is_mac

local md_pdf_group = vim.api.nvim_create_augroup("MarkdownPDF", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = md_pdf_group,
  pattern = "*.md",
  callback = function()
    local input = vim.fn.expand("%:p")
    local output = vim.fn.expand("%:p:r") .. ".pdf"

    vim.fn.jobstart({
      "pandoc",
      input,
      "--pdf-engine=pdflatex",
      "--mathjax",
      "-V", "geometry:margin=2cm",
      "-o", output,
    }, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("PDF actualizado ✓", vim.log.levels.INFO)
          if is_mac then
            vim.fn.jobstart({ "open", "-a", "Skim", output })
          else
            vim.fn.jobstart({ platform.sumatra, output })
          end
        else
          vim.notify("Error al compilar PDF ✗", vim.log.levels.ERROR)
        end
      end,
    })
  end,
})
