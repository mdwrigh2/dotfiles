return {
  'saghen/blink.cmp',
  version = '*',
  event = 'InsertEnter',
  opts = {
    keymap = {
      ['<C-space>'] = { 'show' },
      ['<C-@>'] = { 'show' },
      ['<C-\\>'] = { 'show' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-e>'] = { 'cancel' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down' },
      ['<C-u>'] = { 'scroll_documentation_up' },
    },
    completion = {
      list = {
        selection = { preselect = true, auto_insert = false },
      },
      documentation = { auto_show = true },
      trigger = {
        show_on_keyword = false,
        show_on_trigger_character = true,
      },
    },
    fuzzy = {
      sorts = { 'exact', 'score', 'sort_text' },
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
      providers = {
        buffer = {
          score_offset = -5,
        },
      },
    },
  },
}
