return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
        require('jdtls').start_or_attach({
          cmd = {
            jdtls_path .. '/bin/jdtls',
            '-data', vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
          },
          root_dir = require('jdtls.setup').find_root({ '.git', 'build.gradle', 'pom.xml', 'Android.bp', 'Android.mk' }),
        })
      end,
    })
  end,
}
