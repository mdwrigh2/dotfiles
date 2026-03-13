local servers = {
  'bashls',
  'clangd',
  'gopls',
  'lua_ls',
  'pyright',
  'rust_analyzer',
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
      ensure_installed = servers,
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- LSP keymaps and completion on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
          end

          map('gd', vim.lsp.buf.definition, 'Go to definition')
          map('gr', vim.lsp.buf.references, 'References')
          map('K', vim.lsp.buf.hover, 'Hover')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format')
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
