---@class HexerParser
local M = {
    ---@private
    _utils = require("hexer.parse_utils"),
}

---@alias HexerCharContext table<string, string | nil>
---@alias HexerChar table<string, string>
---@alias HexerItem HexerChar[]

---@param input string
---@param converters HexerConverter[]
---@return HexerItem
function M.parse_input(input, converters)
    local value = tonumber(input)
    if value ~= nil then
        return { M.parse_from_int(value, { value = tostring(value) }, converters) }
    end

    if #input == 1 then
        return { M.parse_from_int(input:byte(1), { ["ascii"] = input }, converters) }
    end

    ---@type HexerItem
    local item = {}

    local head, tail = 1, input:len()

    if M._utils.is_string_wrapped(input) then
        head = head + 1
        tail = tail - 1

        goto string
    end

    for _, converter in ipairs(converters) do
        if converter.is_type(input) then
            return { M.parse_from_int(converter.to_value(input), { [converter.accessor_key] = input }, converters) }
        end
    end

    ::string::

    for i = 1, tail - head + 1 do
        item[i] =
            M.parse_from_int(input:byte(head + i - 1), { ascii = input:sub(head + i - 1, head + i - 1) }, converters)
    end

    return item
end

---Create a HexerChar from a given integer
---@param value integer
---@param context HexerCharContext
---@param converters HexerConverter[]
---@return HexerChar
function M.parse_from_int(value, context, converters)
    ---@type HexerChar
    assert(value ~= nil)

    local item = {
        value = context.value or tostring(value),
    }

    for _, converter in ipairs(converters) do
        item[converter.accessor_key] = context[converter.accessor_key] or converter.from_value(value)
    end

    return item
end

return M
