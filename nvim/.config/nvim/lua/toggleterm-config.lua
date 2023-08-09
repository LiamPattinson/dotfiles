require("toggleterm").setup()

local Terminal  = require('toggleterm.terminal').Terminal

-- general purpose terminal
local general_term = Terminal:new({
    hidden = true,
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    }
})

function _general_term_toggle()
    general_term:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua _general_term_toggle()<CR>", {noremap = true, silent = true})

-- lazygit bits
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    }
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
