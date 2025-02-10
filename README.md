# hexer.nvim

A simple plugin to make working with binary representations painless, fast, and efficient.

![hexer_demo](./assets/hexer_demo.gif)

## Why did I need hexer?

Look, I have an okay workflow. I fullscreen my terminal and my browser, so I can switch between them with one click of a button. This works fine for when I'm researching or looking at requirements. However, when writing assembly code for my classes, constantly switching between neovim and an ascii table is annoying, as well as requiring a couple seconds to search through the table. With hexer, you can quickly convert from one representation to another, as well as easily see multiple at once.

## Usage
*tldr: make sure that inputs are in a proper format, and if you want a character or string, it can never hurt to wrap in quotes!*

`:Hexer 69` opens the following buffer in the lower-right corner of your screen, with your cursor inside of it:

```
┌─────┬─────┬────┬─────────┬─────┐
│Ascii│Value│Hex │Binary   │Octal│
├─────┼─────┼────┼─────────┼─────┤
│E    │69   │0x45│0b1000101│0o105│
└─────┴─────┴────┴─────────┴─────┘
```

This buffer is non-writable, but your cursor can move around in it, which allows you to yank the items you need from it. To leav the buffer, you can use `q` or `esc`. Leaving the buffer will also close it.

Note that hexer is flexible: it will convert from one format to all formats. Thus, this table will also be generated by passing in any of the values listed in that buffer as an argument, e.g. `:Hexer 0x45`. Hexer also makes the leading 0 optional when parsing binary formats. However, the actual character is necessary; thus, this command is equivalent to `:Hexer x45`, but not `:Hexer 45`.

The `:Hexer` command works by working as either a toggle for opening the previous table or parsing a passed argument. The hexer parser tries to read a passed argument as a number first, then as an ascii character, then as a binary format, then finally as a string/array of characters. In order to force hexer to read the argument as a character or string, you can wrap it in either '' or "".

For example, `:Hexer "0x45"` would produce the following table:
```
┌─────┬─────┬────┬─────────┬─────┐
│Ascii│Value│Hex │Binary   │Octal│
├─────┼─────┼────┼─────────┼─────┤
│0    │48   │0x30│0b110000 │0o60 │
├─────┼─────┼────┼─────────┼─────┤
│x    │120  │0x78│0b1111000│0o170│
├─────┼─────┼────┼─────────┼─────┤
│4    │52   │0x34│0b110100 │0o64 │
├─────┼─────┼────┼─────────┼─────┤
│5    │53   │0x35│0b110101 │0o65 │
└─────┴─────┴────┴─────────┴─────┘
```

You can also run `:Hexer` on a highlighted selection in visual mode, allowing for an easier time looking at unfamiliar code. The argument is restricted from being multiple lines, and it is unadvisable to try and parse a string which is too long.

## Installation
*We do be kinda lazy.*

```lua
return {
    "theKnightsOfRohan/hexer.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("hexer").setup()
    end,
}
```

Hexer also exposes two lua functions:
```lua
-- open() parses the passed string arg and opens the hexr buffer, with nil or an empty string representing retaining the past table.
require("hexer"):open(arg)
-- close() is how the hexer buffer closes normally. Useful if you want to remap your own close keys.
-- Note that a BufLeave autocmd is already set for if you leave hexer or open another buffer with it open.
require("hexer"):close()
```

This plugin doesn't take advantage of any special lazy.nvim stuff, just use your other plugin manager's default method.

## TODO
- [ ] Handle negative numbers more gracefully
- [x] Open hexer on highlighted selection
- [ ] Create abstraction for representation format
- [ ] Create config for representation format
- [ ] Create config for hexer popup options
- [ ] Expand into some binary operations?
- [x] Gracefully handle abnormal ascii characters
