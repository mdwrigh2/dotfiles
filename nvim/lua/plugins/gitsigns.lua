return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      map(']h', gs.next_hunk, 'Next hunk')
      map('[h', gs.prev_hunk, 'Previous hunk')
      map('<leader>hs', gs.stage_hunk, 'Stage hunk')
      map('<leader>hr', gs.reset_hunk, 'Reset hunk')
      map('<leader>hp', gs.preview_hunk_inline, 'Preview hunk inline')
      map('<leader>hb', gs.toggle_current_line_blame, 'Toggle line blame')
      map('<leader>hd', gs.diffthis, 'Diff this file')
    end,
  },
}
