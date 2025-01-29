local Popup = require("nui.popup")
local Table = require("nui.table")
local Event = require("nui.utils.autocmd").event
local Parser = require("hexer.parser")

---@class HexerDisplay
---@field _window NuiPopup
---@field _table NuiTable
local M = {
    _window = Popup({
        enter = true,
        focusable = true,
        anchor = "SE",
        border = {
            style = "rounded",
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
        }
    }),
    _table = Table({
        bufnr = 0,
        ns_id = "HexerWindow",
        columns = {
            { accessor_key = "ascii",  header = "Ascii" },
            { accessor_key = "value",  header = "Value" },
            { accessor_key = "hex",    header = "Hex" },
            { accessor_key = "binary", header = "Binary" },
            { accessor_key = "octal",  header = "Octal" },
        },
        ---@type HexerItem
        data = Parser.parse_input("69"),
    }),
    _saved_buf = 0,
    _saved_buf_opts = {
        ["buftype"] = "",
        ["modifiable"] = false,
        ["readonly"] = false,
    }
}

function M.hide_window(self)
    self._window:hide()
    self:_apply_buf_opts()
end

function M._show_window(self)
    self._window:show()
    self._window:on(Event.BufLeave, function()
        self:hide_window()
    end)

    self._window:map("n", "<Esc>", function() self:hide_window() end, {})
    self._window:map("n", "q", function() self:hide_window() end, {})

    self._table.bufnr = self._window.bufnr

    self:_smodify(function()
        vim.api.nvim_buf_set_lines(self._window.bufnr, 0, -1, false, {})
        M._table:render()
    end)
end

---@param fun function
function M._smodify(self, fun)
    vim.api.nvim_set_option_value('modifiable', true, { buf = self._window.bufnr })
    vim.api.nvim_set_option_value('readonly', false, { buf = self._window.bufnr })
    fun()
    vim.api.nvim_set_option_value('modifiable', false, { buf = self._window.bufnr })
    vim.api.nvim_set_option_value('readonly', true, { buf = self._window.bufnr })
end

---Update the table with the new arg
---@param self HexerDisplay
---@param arg string
function M._update_table(self, arg)
    self._table = Table({
        bufnr = 0,
        ns_id = "HexerWindow",
        columns = {
            { accessor_key = "ascii",  header = "Ascii" },
            { accessor_key = "value",  header = "Value" },
            { accessor_key = "hex",    header = "Hex" },
            { accessor_key = "binary", header = "Binary" },
            { accessor_key = "octal",  header = "Octal" },
        },
        ---@type HexerItem
        data = Parser.parse_input(arg),
    })
end

function M._fit_table(self)
    self._window:update_layout({
        size = {
            -- TODO: Why tf do i have to divide by 3, and why does it work??????
            width = vim.api.nvim_buf_get_lines(self._window.bufnr, 0, -1, false)[1]:len() / 3,
            height = vim.api.nvim_buf_line_count(self._window.bufnr),
        },
        relative = "win",
        anchor = "NW",
        position = {
            row = "100%",
            col = "100%"
        },
    })
end

function M.hexer_open(self, arg)
    self:_save_buf_opts()

    if arg ~= nil and arg ~= "" then
        self:_update_table(arg)
    end

    self:_show_window()
    self:_fit_table()
end

-- BUG: Why do we need these in order to prevent buf options from carrying over?
function M._save_buf_opts(self)
    self._saved_buf = vim.fn.bufnr()
    for opt, _ in pairs(self._saved_buf_opts) do
        self._saved_buf_opts[opt] = vim.api.nvim_get_option_value(opt, { buf = self._saved_buf })
    end
end

function M._apply_buf_opts(self)
    for opt, val in pairs(self._saved_buf_opts) do
        vim.api.nvim_set_option_value(opt, val, { buf = self._saved_buf })
    end
end

function M._setup_window(self)
    self._window:mount()
    self._window:hide()
    vim.api.nvim_set_option_value("buflisted", false, { buf = self._window.bufnr })
end

return M
