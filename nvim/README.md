# Neovim Config

## Structure

```
nvim/
├── init.lua          -- Entry point; requires options, keymaps, then lazy
├── lua/
│   ├── config/       -- Lazy.nvim plugin manager bootstrap + setup
│   └── plugins/      -- Lazy.nvim plugin specs (one per file)
└── plugin/           -- Auto-loaded by Neovim; isolated tweaks
```

## Load Order

1. `init.lua` explicitly requires `options` → `keymaps` → `config.lazy` in that order.
2. Lazy.nvim discovers and loads all specs in `lua/plugins/`.
3. Neovim auto-loads everything in `plugin/` (no `require()` needed). Use this
   for standalone tweaks that don't depend on load order.
