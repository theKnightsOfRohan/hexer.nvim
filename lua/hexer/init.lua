---@class Hexer
---@field _parser HexerParser
---@field _display HexerDisplay
local M = {
    _parser = require("hexer.parser"),
    _display = require("hexer.display"),
}

M.hexer_open = M._display.hexer_open
M.hexer_close = M._display.hide_window

function M.setup()
    vim.api.nvim_create_user_command("Hexer", function(opts)
        M._display:hexer_open(opts.args)
    end, { nargs = "?" })
end

return M
