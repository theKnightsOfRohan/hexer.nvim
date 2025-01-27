local M = {
    ---@private
    _utils = require("hexer.parse_utils")
}

---@class HexerCharContext
---@field ascii? string
---@field value? string
---@field hex? string
---@field binary? string
---@field octal? string

---@class HexerChar
---@field ascii string
---@field value string
---@field hex string
---@field binary string
---@field octal string

---@alias HexerItem HexerChar[]

---Parse an input given by the user into a HexerItem, last resorts to string
---@param input string
---@return HexerItem
function M.parse_input(input)
    local value = tonumber(input)
    if value ~= nil then
        return { M.parse_from_int(value, { value = tostring(value) }) }
    end

    if #input == 1 then return { M.parse_from_int(input:byte(1), { ascii = input }) } end

    local head, tail = 1, input:len()
    local orig_head = head

    head = M._utils.check_header(input, { 'x', 'X' })
    if head ~= orig_head then return { M.parse_from_int(M._utils.xtoi(input:sub(head)), { hex = input }) } end

    head = M._utils.check_header(input, { 'b', 'B' })
    if head ~= orig_head then return { M.parse_from_int(M._utils.btoi(input:sub(head)), { binary = input }) } end

    head = M._utils.check_header(input, { 'o', 'O' })
    if head ~= orig_head then return { M.parse_from_int(M._utils.otoi(input:sub(head)), { octal = input }) } end

    ---@type HexerItem
    local item = {}

    if M._utils.is_string_wrapped(input) then
        head = head + 1
        tail = tail - 1
    end

    for i = head, tail do
        item[i - 1] = M.parse_from_int(input:byte(i), { ascii = input:sub(i, i) })
    end

    return item
end

---Create a HexerChar from a given integer
---@param value integer
---@param context HexerCharContext
---@return HexerChar
function M.parse_from_int(value, context)
    ---@type HexerChar
    local item = {
        value = context.value or tostring(value),
        hex = context.hex or ("0x" .. string.format("%X", value)),
        octal = context.octal or ("0o" .. string.format("%o", value)),
        ascii = context.ascii or (string.format("%c", value)),
        binary = context.binary or ("0b" .. M._utils.itob(value)),
    }

    return item
end

return M
