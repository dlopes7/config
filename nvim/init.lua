vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>d", ":t.<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

vim.pack.add{
  -- lsp
  {src = "https://github.com/neovim/nvim-lspconfig"},
  {src = "https://github.com/mason-org/mason.nvim"},
  {src = "https://github.com/mason-org/mason-lspconfig.nvim"},

  -- picker
  {src = "https://github.com/nvim-mini/mini.pick"},

   -- telescope
  {src = "https://github.com/nvim-telescope/telescope.nvim"},
  {src = "https://github.com/nvim-lua/plenary.nvim"},
  {src = "https://github.com/nvim-telescope/telescope-file-browser.nvim"}
}

require("mason").setup()
require("mason-lspconfig").setup{
   ensure_installed = {"lua_ls", "pyright"},
}

require("mini.pick").setup()
require("telescope").setup()
require("telescope").load_extension "file_browser"
