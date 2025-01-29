---@class Hexer
---@field _parser HexerParser
---@field _display HexerDisplay
local M = {
    _parser = require("hexer.parser"),
    _display = require("hexer.display"),
}

M.open = function(self, arg) self._display:hexer_open(arg) end
M.close = function(self) self._display:hide_window() end

function M.setup()
    M._display:_setup_window()

    vim.api.nvim_create_user_command("Hexer", function(opts)
        M._display:hexer_open(opts.args)
    end, { nargs = "?" })
end

return M
