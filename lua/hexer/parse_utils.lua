local M = {}

---Integer in decimal form to binary string
---@param input integer
---@return string
function M.itob(input)
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
function M.check_header(str, header)
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

-- Check whether a passed string is wrapped by quotes
---@param str string
---@return boolean
function M.is_string_wrapped(str)
    return #str >= 3 and (
        (str:sub(1, 1) == '"' and str:sub(str:len()) == '"') or
        (str:sub(1, 1) == "'" and str:sub(str:len()) == "'")
    )
end

---String in decimal form to integer
---@param input string
---@return integer
function M.stoi(input)
    return tonumber(input, 10);
end

---String in decimal form to integer
---@param input string
---@return integer
function M.xtoi(input)
    return tonumber(input, 16);
end

---String in decimal form to integer
---@param input string
---@return integer
function M.btoi(input)
    return tonumber(input, 2);
end

---String in decimal form to integer
---@param input string
---@return integer
function M.otoi(input)
    return tonumber(input, 8);
end

return M
