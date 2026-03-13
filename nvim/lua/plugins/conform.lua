return {
  'stevearc/conform.nvim',
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      desc = 'Format',
    },
  },
  opts = {
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      css = { 'prettier' },
      go = { 'goimports' },
      html = { 'prettier' },
      java = { 'google-java-format' },
      javascript = { 'prettier' },
      json = { 'prettier' },
      kotlin = { 'ktlint' },
      lua = { 'stylua' },
      markdown = { 'prettier' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      typescript = { 'prettier' },
      yaml = { 'prettier' },
    },
  },
}
