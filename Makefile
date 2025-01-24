fmt:
	echo "===> Formatting"
	stylua lua/ --config-path=.stylua.toml

lint:
	echo "===> Linting"
	luacheck lua/ --globals vim

test:
	echo "===> Testing"
	nvim --headless --noplugin -u lua/hexer/tests/minimal_init.lua -c "PlenaryBustedDirectory lua/hexer/tests/ { minimal_init = 'lua/hexer/tests/minimal_init.lua' }"

clean:
	echo "===> Cleaning testing dependencies"
	rm -rf /tmp/hexer_test/plenary.nvim
	rm -rf /tmp/hexer_test/nui.nvim

all:
	make fmt lint test
