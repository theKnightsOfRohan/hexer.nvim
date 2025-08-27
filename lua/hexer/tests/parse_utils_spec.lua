local Utils = require("hexer.parse_utils")

describe("Parse Utils", function()
    it("should be able to detect whether a passed string is quoted", function()
        local strs = {
            ["''"] = false,
            ['""'] = false,
            ["potato"] = false,
            ["'p'"] = true,
            ['"p"'] = true,
            ["'potato'"] = true,
            ['"potato"'] = true,
            ["potato'"] = false,
            ["'potato"] = false,
            ['potato"'] = false,
            ['"potato'] = false,
        }

        local res

        for str, q in pairs(strs) do
            res = Utils.is_string_wrapped(str) == q
            assert(res, ("%s expected to be %s but got %s"):format(str, q, res))
        end
    end)

    it("should see if a given string contains the header", function()
        local strs = { "0b0011", "B0011" }
        local headers = { { "b", "B" }, { "x", "X" } }

        local val_pos = Utils.check_header(strs[1], headers[1])

        assert(
            val_pos == 3,
            ("String %s with headers %s expected pos %s but got %s"):format(
                strs[1],
                vim.inspect(headers[1]),
                3,
                val_pos
            )
        )

        val_pos = Utils.check_header(strs[1], headers[2])

        assert(
            val_pos == 1,
            ("String %s with headers %s expected pos %s but got %s"):format(
                strs[1],
                vim.inspect(headers[2]),
                1,
                val_pos
            )
        )

        val_pos = Utils.check_header(strs[2], headers[1])

        assert(
            val_pos == 2,
            ("String %s with headers %s expected pos %s but got %s"):format(
                strs[2],
                vim.inspect(headers[1]),
                2,
                val_pos
            )
        )

        val_pos = Utils.check_header(strs[2], headers[2])

        assert(
            val_pos == 1,
            ("String %s with headers %s expected pos %s but got %s"):format(
                strs[2],
                vim.inspect(headers[2]),
                1,
                val_pos
            )
        )
    end)
end)
