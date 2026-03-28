# tabme

A Neovim plugin to pin a tab (buffer) and highlight it for easy focus.

## Features

- Pin a specific buffer and highlight it in the tabline.
- Always visually easy to spot.
- Only one pin at a time to help focus.
- Shortcut to pin/unpin and shortcut to focus on the pinned buffer from anywhere.
- Pins the buffer, not the file (so you can work on different files in that buffer if needed, though usually, it's for a main file).

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "wiccy46/tabme",
    config = function()
        require("tabme").setup({
            tabline = true, -- Enable custom tabline to see the pin
        })
    end,
}
```

## Default Keybindings

- `<leader>tp`: Pin/Unpin the current buffer.
- `<leader>tf`: Focus the pinned buffer (jumps to the window if already open, otherwise switches to it in current window).

## Configuration

```lua
require("tabme").setup({
    keybindings = {
        pin = "<leader>tp",
        focus = "<leader>tf",
    },
    tabline = false, -- Whether to override the tabline
    highlight = {
        link = "Title", -- Highlight group for the pinned tab
        bold = true,
    },
})
```

## Custom UI Integration (NvChad, Lualine, etc.)

If you use a custom tabline or statusline plugin (e.g., NvChad, `lualine.nvim`, `bufferline.nvim`), do **not** set `tabline = true` in the `setup`. Instead, use the `is_pinned` or `format` helpers.

### NvChad / Custom Tablines
You can integrate `tabme` into your existing tabline by checking if a buffer is pinned:

```lua
-- Example: Get the formatted name with highlight if pinned
local name = require("tabme").format(bufnr)
```

### Lualine Example
```lua
sections = {
  lualine_b = {
    {
      function()
        return require("tabme").is_pinned() and "📌" or ""
      end
    }
  }
}
```
