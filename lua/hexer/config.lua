---@class HexerConfig
---@field converters HexerConverterGroup
---@field popup_opts nui_popup_options
---@field table_opts nui_table_options
local M = {
    converters = require("hexer.converters"),
    popup_opts = {
        enter = true,
        focusable = true,
        anchor = "SE",
        border = {
            style = "none",
        },
        position = {
            row = "100%",
            col = "100%",
        },
        size = {
            width = 420,
            height = 69,
        },
        buf_options = {
            buftype = "nofile",
            buflisted = false,
            modifiable = false,
        },
    },
    ---@diagnostic disable-next-line: missing-fields
    table_opts = {
        bufnr = 0,
        ns_id = "HexerWindow",
    },
}

---@class HexerPartialConfig
---@field converters HexerConverterGroup?
---@field popup_opts nui_popup_options
---@field table_opts nui_table_options

return M
