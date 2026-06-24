return {
  "arminveres/md-pdf.nvim",
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      function() require("md-pdf").convert_md_to_pdf() end,
      desc = "Markdown → PDF (Skim)",
    },
  },
  opts = {
    pdf_viewer = "skim",
    highlight = "pygments",  -- syntax highlighting en código
    toc = false,
  },
}
