local Parser = require("hexer.parser")

describe("Parser", function()
    ---@type HexerChar
    local base_target = {
        value = "69",
        ascii = "E",
        binary = "0b1000101",
        hex = "0x45",
        octal = "0o105",
    }

    it("should be able to parse from a decimal value", function()
        local parsed = Parser.parse_from_int(69, {})

        for k, v in pairs(base_target) do
            assert(v == parsed[k], string.format("Key %s: %s != %s", tostring(k), tostring(v), tostring(parsed[k])))
        end
    end)

    it("should be able to parse from a decimal string", function()
        local parsed = Parser.parse_input("69")

        assert(#parsed == 1, string.format("Decimal string: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(base_target) do
            assert(v == parsed[1][k], string.format("Decimal string: %s != %s", tostring(v), tostring(parsed[1][k])))
        end
    end)

    it("should be able to parse from an ascii character", function()
        local parsed = Parser.parse_input("E")
        assert(parsed)

        assert(#parsed == 1, string.format("Ascii character: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(base_target) do
            assert(v == parsed[1][k],
                string.format("Ascii character: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end
    end)

    it("should be able to parse from a binary string", function()
        local parsed = Parser.parse_input("0b1000101")
        assert(parsed)

        assert(#parsed == 1, string.format("Binary: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(base_target) do
            assert(v == parsed[1][k],
                string.format("Binary: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end
    end)

    it("should be able to parse from a hex string", function()
        local parsed = Parser.parse_input("0x45")
        assert(parsed)

        assert(#parsed == 1, string.format("Hexadecimal: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(base_target) do
            assert(v == parsed[1][k],
                string.format("Hexadecimal: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end
    end)

    it("should be able to parse from a octal string", function()
        local parsed = Parser.parse_input("0o105")
        assert(parsed)

        assert(#parsed == 1, string.format("Octal: expected length 1, is instead %s", tostring(#parsed)))

        for k, v in pairs(base_target) do
            assert(v == parsed[1][k],
                string.format("Octal: expected %s, actual %s", tostring(v), tostring(parsed[1][k])))
        end
    end)

    it("should be able to parse a multi-character string", function()
        local parsed = Parser.parse_input("\"EEEE\"")

        assert(parsed)

        assert(#parsed == 4, string.format("String: expected length 4, got %s", tostring(#parsed)))

        for _, item in pairs(parsed) do
            assert(item)

            for k, v in pairs(base_target) do
                assert(v == item[k],
                    string.format("String: expected %s, actual %s", tostring(v), tostring(item[k])))
            end
        end

        parsed = Parser.parse_input("EEEE")

        assert(parsed)

        assert(#parsed == 4, string.format("String: expected length 4, got %s", tostring(#parsed)))

        for _, item in pairs(parsed) do
            assert(item)

            for k, v in pairs(base_target) do
                assert(v == item[k],
                    string.format("String: expected %s, actual %s", tostring(v), tostring(item[k])))
            end
        end
    end)
end)
