local plenary_dir = "/tmp/hexer_test/plenary.nvim"
local is_not_a_directory = vim.fn.isdirectory(plenary_dir) == 0
if is_not_a_directory then
    print("===> Cloning testing dependency Plenary")
    vim.fn.system({ "git", "clone", "https://github.com/nvim-lua/plenary.nvim", plenary_dir })
end

local nui_dir = "/tmp/hexer_test/nui.nvim"
is_not_a_directory = vim.fn.isdirectory(nui_dir) == 0

if is_not_a_directory then
    print("===> Cloning testing dependency Nui")
    vim.fn.system({ "git", "clone", "https://github.com/MunifTanjim/nui.nvim", nui_dir })
end

vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_dir)
vim.opt.rtp:append(nui_dir)

vim.cmd("runtime plugin/plenary.vim")
vim.cmd("runtime plugin/nui.vim")
