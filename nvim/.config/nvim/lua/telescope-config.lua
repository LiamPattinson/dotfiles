require('telescope').setup({
    extensions = {
        file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            hidden = {file_browser = true, folder_browser = true},
            depth = 5,
        }
    }
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)
