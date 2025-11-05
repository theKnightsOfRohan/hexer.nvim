---@class Hexer
---@field _parser HexerParser
---@field _display HexerDisplay
---@field _config HexerConfig
local M = {
    _parser = require("hexer.parser"),
    _display = require("hexer.display"),
    _config = require("hexer.config"),
}

M.open = function(self, arg)
    self._display:hexer_open(arg)
end
M.close = function(self)
    self._display:hide_window()
end

---@param config HexerPartialConfig?
function M.setup(config)
    if config ~= nil then
        -- NOTE: Hack to work around tbl_deep_extend not working on arrays
        local all_converters = {}

        for _, v in ipairs(M._config.converters) do
            table.insert(all_converters, v)
        end
        for _, v in ipairs(config.converters) do
            table.insert(all_converters, v)
        end

        vim.tbl_deep_extend("force", M._config, config)

        M._config.converters = all_converters
    end

    M._display:_setup_window(M._config)

    vim.api.nvim_create_user_command("Hexer", function(opts)
        local str = opts.args or ""

        -- Means that a range was supplied to the command, AKA called in visual mode
        if opts.count ~= -1 then
            local s_start = vim.fn.getpos("'<")
            local s_end = vim.fn.getpos("'>")
            local text = vim.api.nvim_buf_get_text(0, s_start[2] - 1, s_start[3] - 1, s_end[2] - 1, s_end[3], {})[1]

            if text ~= "" then
                if s_start[2] ~= s_end[2] then
                    vim.notify("Hexer can only operate on single-line strings!", vim.log.levels.ERROR)
                    return
                else
                    str = text
                end
            end
        end

        M._display:hexer_open(str)
    end, { nargs = "?", range = true })
end

return M
