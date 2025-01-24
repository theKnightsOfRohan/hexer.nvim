local Popup = require("nui.popup")
local Table = require("nui.table")
local Event = require("nui.utils.autocmd").event
local Parser = require("hexer.parser")

---@param data HexerItem
---@return NuiTable
local function new_table(data)
    return Table({
        bufnr = 0,
        ns_id = "HexerWindow",
        columns = {
            { accessor_key = "ascii",  header = "Ascii" },
            { accessor_key = "value",  header = "Value" },
            { accessor_key = "hex",    header = "Hex" },
            { accessor_key = "binary", header = "Binary" },
            { accessor_key = "octal",  header = "Octal" },
        },
        data = data,
    })
end

local M = {
    ---@type HexerItem
    current_value = nil,
    _window = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
        },
        position = {
            row = "100%",
            col = "100%",
        },
        size = {
            width = 33,
            height = 11,
        },
    }),
    -- _table = new_table(Parser.parse_input("x69")),
}

function M.hide_window(self)
    self._window:unmount()
end

function M.show_window(self)
    self._window:mount()
    self._window:on(Event.BufLeave, function()
        self:hide_window()
    end)

    self._window:map("n", "<Esc>", function() self:hide_window() end, {})
    self._window:map("n", "q", function() self:hide_window() end, {})

    self._table.bufnr = self._window.bufnr

    vim.api.nvim_buf_set_lines(self._window.bufnr, 0, -1, false, {})

    M._table:render()
    self._window:update_layout({
        size = {
            width = 33,
            height = 20,
        }
    })
end

-- Create a hexer buffer; if the value is null, will display the previously displayed value.
---@param self table
function M.toggle_window(self)
    if self.window ~= nil then
        self:show_window()
    else
        self:hide_window()
    end
end

function M.update_table(self, arg)
end

function M.setup()
    vim.api.nvim_create_user_command("Hexer", function(opts)
        if opts.args ~= nil then
            M:update_table(arg)
        end

        M:show_window()
    end, {})
end

return M
