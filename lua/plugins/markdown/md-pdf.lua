return {
  "arminveres/md-pdf.nvim",
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      function() require("md-pdf").convert_md_to_pdf() end,
      desc = "Markdown → PDF",
    },
  },
  opts = {
    -- En macOS se usa el visor por defecto (open); en WSL, SumatraPDF de Windows
    preview_cmd = require("core.platform").is_wsl and require("core.platform").sumatra or nil,
    highlight = "pygments",  -- syntax highlighting en código
    toc = false,
  },
}
