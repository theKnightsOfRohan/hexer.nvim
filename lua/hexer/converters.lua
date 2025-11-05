local Utils = require("hexer.parse_utils")

---@class HexerConverter
---@field accessor_key string
---@field header string
---@field is_type fun(str: string): boolean
---@field to_value fun(str: string): integer
---@field from_value fun(value: integer): string

---@alias HexerConverterGroup HexerConverter[]

---@type HexerConverterGroup
local M = {
    ---@type HexerConverter
    {
        accessor_key = "ascii",
        header = "Ascii",
        is_type = function(str)
            if #str == 1 then
                return true
            else
                return false
            end
        end,
        to_value = function(str)
            assert(#str == 1, "ascii can only parse one character at a time")
            return str:byte(1)
        end,
        from_value = function(value)
            local codes = {
                [0] = "NUL",
                [1] = "SOH",
                [2] = "STX",
                [3] = "ETX",
                [4] = "EOT",
                [5] = "ENQ",
                [6] = "ACK",
                [7] = "BEL",
                [8] = "BS",
                [9] = "HT",
                [10] = "LF",
                [11] = "VT",
                [12] = "FF",
                [13] = "CR",
                [14] = "SO",
                [15] = "SI",
                [16] = "DLE",
                [17] = "DC1",
                [18] = "DC2",
                [19] = "DC3",
                [20] = "DC4",
                [21] = "NAK",
                [22] = "SYN",
                [23] = "ETB",
                [24] = "CAN",
                [25] = "EM",
                [26] = "SUB",
                [27] = "ESC",
                [28] = "FS",
                [29] = "GS",
                [30] = "RS",
                [31] = "US",
                [32] = "SP",
                [127] = "DEL",
            }
            return codes[value] or (string.format("%c", value))
        end,
    },
    ---@type HexerConverter
    {
        accessor_key = "hex",
        header = "Hex",
        is_type = function(str)
            return Utils.check_prefix(str, { "x", "X", "0x", "0X" }) ~= 1
        end,
        to_value = function(str)
            return tonumber(str, 16)
        end,
        from_value = function(value)
            return "0x" .. string.format("%X", value)
        end,
    },
    ---@type HexerConverter
    {
        accessor_key = "binary",
        header = "Binary",
        is_type = function(str)
            return Utils.check_prefix(str, { "b", "b", "0b", "0B" }) ~= 1
        end,
        to_value = function(str)
            return tonumber(str, 2)
        end,
        from_value = function(value)
            if value == 0 then
                return "0b0"
            end

            if value < 0 then
                value = math.abs(value)
            end

            local result = ""

            while value > 0 do
                local remainder = value % 2
                result = remainder .. result
                value = math.floor(value / 2)
            end

            return "0b" .. result
        end,
    },
    ---@type HexerConverter
    {
        accessor_key = "octal",
        header = "Octal",
        is_type = function(str)
            return Utils.check_prefix(str, { "o", "O", "0o", "0O" }) ~= 1
        end,
        to_value = function(str)
            return tonumber(str:sub(Utils.check_prefix(str, { "o", "O", "0o", "0O" })), 8)
        end,
        from_value = function(value)
            return "0o" .. string.format("%o", value)
        end,
    },
}

return M
