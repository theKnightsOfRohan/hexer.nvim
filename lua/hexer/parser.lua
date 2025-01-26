local M = {
    ---@private
    _utils = require("hexer.parse_utils")
}


---@class HexerChar
---@field ascii string
---@field value integer
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
        return { M.parse_from_int(value) }
    end

    if #input == 1 then return { M.parse_from_int(input:byte(1)) } end

    local head, tail = 1, input:len()
    local orig_head = head


    head = M._utils.check_header(input, { 'x', 'X' })
    if head ~= orig_head then return { M.parse_from_int(M._utils.xtoi(input:sub(head))) } end

    head = M._utils.check_header(input, { 'b', 'B' })
    if head ~= orig_head then return { M.parse_from_int(M._utils.btoi(input:sub(head))) } end

    head = M._utils.check_header(input, { 'o', 'O' })
    if head ~= orig_head then return { M.parse_from_int(M._utils.otoi(input:sub(head))) } end

    ---@type HexerItem
    local item = {}

    if M._utils.is_string_wrapped(input) then
        head = head + 1
        tail = tail - 1
    end

    for i = head, tail do
        item[i] = M.parse_from_int(input:byte(i))
    end

    return item
end

---Create a HexerChar from a given integer
---@param value integer
---@return HexerChar
function M.parse_from_int(value)
    ---@type HexerChar
    local item = {
        value = value,
        hex = "0x" .. string.format("%X", value),
        octal = "0o" .. string.format("%o", value),
        ascii = string.format("%c", value),
        binary = "0b" .. M._utils.itob(value),
    }

    return item
end

return M
