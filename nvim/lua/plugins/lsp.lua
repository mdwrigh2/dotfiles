local servers = {
  'bashls',
  'clangd',
  'cssls',
  'gopls',
  'html',
  'kotlin_language_server',
  'lua_ls',
  'marksman',
  'pyright',
  'rust_analyzer',
  'ts_ls',
}

return {
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      -- jdtls is installed by mason but managed by nvim-jdtls, not nvim-lspconfig
      ensure_installed = vim.list_extend({ 'jdtls' }, servers),
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      ensure_installed = {
        'clang-format',
        'goimports',
        'google-java-format',
        'ktlint',
        'prettier',
        'shellcheck',
        'shfmt',
        'stylua',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
          end

          map('gd', vim.lsp.buf.definition, 'Go to definition')
          map('gD', vim.lsp.buf.declaration, 'Go to declaration')
          map('gi', vim.lsp.buf.implementation, 'Go to implementation')
          map('gr', vim.lsp.buf.references, 'References')
          map('K', vim.lsp.buf.hover, 'Hover')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>D', vim.lsp.buf.type_definition, 'Type definition')
          map('[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Previous diagnostic')
          map(']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')
          map('<leader>d', vim.diagnostic.open_float, 'Line diagnostics')
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
