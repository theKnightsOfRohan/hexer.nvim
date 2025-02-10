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
        [127] = "DEL"
    }

    local out = codes[value] or context.ascii or (string.format("%c", value))
    return out
end

return M
