local M = {}

---@class HexerChar
---@field ascii string
---@field value integer
---@field hex string
---@field binary string
---@field octal string

---@alias HexerItem HexerChar[]

-- Check whether a passed string is wrapped by quotes
---@param str string
---@return boolean
function M._is_string_wrapped(str)
    return #str >= 3 and (
        (str:sub(1, 1) == '"' and str:sub(str:len()) == '"') or
        (str:sub(1, 1) == "'" and str:sub(str:len()) == "'")
    )
end

---Parse an input given by the user into a HexerItem, last resorts to string
---@param input string
---@return HexerItem
function M.parse_input(input)
    local value = tonumber(input)
    if value ~= nil then
        return { M._parse_from_int(value) }
    end

    if #input == 1 then return { M._parse_from_int(input:byte(1)) } end

    local head, tail = 1, input:len()
    local orig_head = head


    head = M._check_header(input, { 'x', 'X' })
    if head ~= orig_head then return { M._parse_from_int(M._xtoi(input:sub(head))) } end

    head = M._check_header(input, { 'b', 'B' })
    if head ~= orig_head then return { M._parse_from_int(M._btoi(input:sub(head))) } end

    head = M._check_header(input, { 'o', 'O' })
    if head ~= orig_head then return { M._parse_from_int(M._otoi(input:sub(head))) } end

    ---@type HexerItem
    local item = {}

    if M._is_string_wrapped(input) then
        head = head + 1
        tail = tail - 1
    end

    for i = head, tail do
        item[i] = M._parse_from_int(input:byte(i))
    end

    return item
end

---String in decimal form to integer
---@param input string
---@return integer
function M._stoi(input)
    return tonumber(input, 10);
end

---String in decimal form to integer
---@param input string
---@return integer
function M._xtoi(input)
    return tonumber(input, 16);
end

---String in decimal form to integer
---@param input string
---@return integer
function M._btoi(input)
    return tonumber(input, 2);
end

---String in decimal form to integer
---@param input string
---@return integer
function M._otoi(input)
    return tonumber(input, 8);
end

---Integer in decimal form to binary string
---@param input integer
---@return string
function M._itob(input)
    if input == 0 then
        return "0"
    end

    if input < 0 then
        input = math.abs(input)
    end

    local result = ""

    while input > 0 do
        local remainder = input % 2
        result = remainder .. result
        input = math.floor(input / 2)
    end

    return result
end

---Checks if the string has the given number format header and returns the start of the value if it does, otherwise 1
---@param str string
---@param header string[] the list of single-character format specifiers
---@return integer
function M._check_header(str, header)
    for _, ch in ipairs(header) do
        if str:sub(1, 1) == ch then
            return 2
        end

        -- Should never occur, but just in case
        if str:sub(1, 1) == '0' and str:sub(2, 2) == ch then
            return 3
        end
    end

    return 1
end

---Create a HexerChar from a given integer
---@param value integer
---@return HexerChar
function M._parse_from_int(value)
    ---@type HexerChar
    local item = {
        value = value,
        hex = "0x" .. string.format("%X", value),
        octal = "0o" .. string.format("%o", value),
        ascii = string.format("%c", value),
        binary = "0b" .. M._itob(value),
    }

    return item
end

return M
