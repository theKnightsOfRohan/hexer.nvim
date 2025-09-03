---@class HexerConverter
---@field accessor_key string
---@field header string
---@field prefixes string[]
---@field to_value fun(str: string, head: integer): integer
---@field from_value fun(value: integer): string

---@type HexerConverter[]
local Mn = {
    ---@type HexerConverter
    ascii = {
        accessor_key = "ascii",
        header = "Ascii",
        prefixes = {},
        to_value = function(str, head)
            assert(#str == 1, "ascii can only parse one character at a time")
            return str:byte(1);
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
    hexadecimal = {
        accessor_key = "hex",
        header = "Hex",
        prefixes = { "x", "X", "0x", "0X" },
        to_value = function(str, head)
            return tonumber(str:sub(head), 16)
        end,
        from_value = function(value)
            return "0x" .. string.format("%X", value)
        end,
    },
    ---@type HexerConverter
    binary = {
        accessor_key = "binary",
        header = "Binary",
        prefixes = { "b", "b", "0b", "0B" },
        to_value = function(str, head)
            return tonumber(str:sub(head), 2)
        end,
        from_value = function(value)
            if value == 0 then
                return "0"
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

            return result
        end,
    },
    ---@type HexerConverter
    octal = {
        accessor_key = "octal",
        header = "Octal",
        prefixes = { "o", "O", "0o", "0O" },
        to_value = function(str, head)
            return tonumber(str:sub(head), 8)
        end,
        from_value = function(value)
            return "0o" .. string.format("%o", value)
        end,
    },
}

---@class HexerConverters
local M = {}

---@param value integer
---@param context HexerCharContext
---@return string
function M.ascii(value, context)
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

    local out = codes[value] or context.ascii or (string.format("%c", value))
    return out
end

return M
