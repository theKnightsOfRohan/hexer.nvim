local Parser = require("hexer.parser")

describe("Parser", function()
    it("should be able to detect whether a passed string is quoted", function()
        local strs = {
            ["''"] = false,
            ['""'] = false,
            ["potato"] = false,
            ["'p'"] = true,
            ['"p"'] = true,
            ["'potato'"] = true,
            ['"potato"'] = true
        }

        local res

        for str, q in pairs(strs) do
            res = Parser._is_string_wrapped(str) == q
            assert(res, ("%s expected to be %s but got %s"):format(str, q, res))
        end
    end)

    it("should correctly see if a given string contains the header", function()
        local strs = { "0b0011", "B0011" }
        local headers = { { "b", "B" }, { "x", "X" } }

        local val_pos = Parser._check_header(strs[1], headers[1])

        assert(val_pos == 3,
            ("String %s with headers %s expected pos %s but got %s"):format(strs[1], vim.inspect(headers[1]), 3, val_pos)
        )

        val_pos = Parser._check_header(strs[1], headers[2])

        assert(val_pos == 0,
            ("String %s with headers %s expected pos %s but got %s"):format(strs[1], vim.inspect(headers[2]), 0, val_pos)
        )

        val_pos = Parser._check_header(strs[2], headers[1])

        assert(val_pos == 2,
            ("String %s with headers %s expected pos %s but got %s"):format(strs[2], vim.inspect(headers[1]), 2, val_pos)
        )

        val_pos = Parser._check_header(strs[2], headers[2])

        assert(val_pos == 0,
            ("String %s with headers %s expected pos %s but got %s"):format(strs[2], vim.inspect(headers[2]), 0, val_pos)
        )
    end)

    it("should be able to correctly parse from a decimal value", function()
        local parsed = Parser._parse_from_int(69)

        ---@type HexerChar
        local target = {
            value = 69,
            ascii = "E",
            binary = "0b1000101",
            hex = "0x45",
            octal = "0o105",
        }

        for k, v in pairs(target) do
            assert(v == parsed[k], string.format("Key %s: %s != %s", tostring(k), tostring(v), tostring(parsed[k])))
        end
    end)

    it("should be able to correctly parse from string inputs", function()
        local target = {
            value = 69,
            ascii = "E",
            binary = "0b1000101",
            hex = "0x45",
            octal = "0o105",
        }

        local parsed = Parser.parse_input("69")

        assert(#parsed == 1, string.format("Decimal string: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(target) do
            assert(v == parsed[1][k], string.format("Decimal string: %s != %s", tostring(v), tostring(parsed[1][k])))
        end

        parsed = Parser.parse_input("E")
        assert(parsed)

        assert(#parsed == 1, string.format("Ascii character: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(target) do
            assert(v == parsed[1][k],
                string.format("Ascii character: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end

        parsed = Parser.parse_input("0b1000101")
        assert(parsed)

        assert(#parsed == 1, string.format("Binary: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(target) do
            assert(v == parsed[1][k],
                string.format("Binary: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end

        parsed = Parser.parse_input("0x45")
        assert(parsed)

        assert(#parsed == 1, string.format("Hexadecimal: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(target) do
            assert(v == parsed[1][k],
                string.format("Hexadecimal: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end

        parsed = Parser.parse_input("0o105")
        assert(parsed)

        assert(#parsed == 1, string.format("Octal: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(target) do
            assert(v == parsed[1][k],
                string.format("Octal: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end
    end)
end)
