local Popup = require("nui.popup")
local Table = require("nui.table")
local Event = require("nui.utils.autocmd").event
local Parser = require("hexer.parser")

---@class HexerDisplay
---@field _window NuiPopup
---@field _table NuiTable
---@field _popup_opts nui_popup_options
---@field _table_opts nui_table_options
---@field _converters HexerConverterGroup
local M = {
    _saved_buf = 0,
    _saved_buf_opts = {
        ["buftype"] = "",
        ["modifiable"] = false,
        ["readonly"] = false,
    },
}

---Create and return a new window and table with updated config
---@param self HexerDisplay
---@param new_popup_config table
---@param new_table_config table
---@return NuiPopup, NuiTable
function M._create_win(self, new_popup_config, new_table_config)
    self._popup_opts = vim.tbl_deep_extend("force", self._popup_opts, new_popup_config)
    local _w = Popup(self._popup_opts)
    self._table_opts = vim.tbl_deep_extend("force", self._table_opts, new_table_config)
    self._table_opts.bufnr = _w.bufnr
    local _t = Table(self._table_opts)

    return _w, _t
end

---Hide the hexer window. Already bound to q & esc by default.
---@param self HexerDisplay
function M.hide_window(self)
    self._window:hide()
    self:_apply_buf_opts()
end

function M._show_window(self)
    -- https://github.com/theKnightsOfRohan/hexer.nvim/issues/2
    if not vim.api.nvim_win_is_valid(self._window.win_config.win) then
        vim.notify("Hexer window invalid, recreating...", vim.log.levels.WARN)
        self._window, self._table = self:_create_win({}, {})
    end

    self._window:show()
    self._window:on(Event.BufLeave, function()
        self:hide_window()
    end)

    self._window:map("n", "<Esc>", function()
        self:hide_window()
    end, {})
    self._window:map("n", "q", function()
        self:hide_window()
    end, {})

    self._table.bufnr = self._window.bufnr

    self:_smodify(function()
        vim.api.nvim_buf_set_lines(self._window.bufnr, 0, -1, false, {})
        self._table:render(1)
    end)
end

---@param fun function
function M._smodify(self, fun)
    vim.api.nvim_set_option_value("modifiable", true, { buf = self._window.bufnr })
    vim.api.nvim_set_option_value("readonly", false, { buf = self._window.bufnr })
    fun()
    vim.api.nvim_set_option_value("modifiable", false, { buf = self._window.bufnr })
    vim.api.nvim_set_option_value("readonly", true, { buf = self._window.bufnr })
end

---Update the table with the new arg
---@param self HexerDisplay
---@param arg string
function M._update_table(self, arg)
    self._table =
        Table(vim.tbl_deep_extend("force", self._table_opts, { data = Parser.parse_input(arg, self._converters) }))
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
            col = "100%",
        },
    })
end

---Opens the hexer buffer and updates it with the parsed arg.
---@param self HexerDisplay
---@param arg string | nil If nil or empty, will toggle buffer without updating
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

---Generate table columns from converter list
---@param converters HexerConverterGroup
---@return NuiTable.ColumnDef[]
function M._generate_columns(converters)
    ---@type NuiTable.ColumnDef[]
    local ret = { { accessor_key = "value", header = "Value" } }
    local i = 2
    for _, converter in ipairs(converters) do
        ret[i] = { accessor_key = converter.accessor_key, header = converter.header }
        i = i + 1
    end

    return ret
end

---@param self HexerDisplay
---@param config HexerConfig
function M._setup_window(self, config)
    self._popup_opts = config.popup_opts
    self._table_opts = config.table_opts

    self._converters = config.converters

    self._window, self._table = self:_create_win({}, {
        columns = self._generate_columns(self._converters),
        data = Parser.parse_input("69", self._converters),
    })

    self._window:mount()
    self._window:hide()
    vim.api.nvim_set_option_value("buflisted", false, { buf = self._window.bufnr })
end

return M
