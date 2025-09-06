vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>d", ":t.<CR>")

vim.pack.add{
  {src = "https://github.com/neovim/nvim-lspconfig"},
  {src = "https://github.com/mason-org/mason.nvim"},
  {src = "https://github.com/mason-org/mason-lspconfig.nvim"},
  {src = "https://github.com/stevearc/oil.nvim"},
  {src = "https://github.com/nvim-mini/mini.pick"}
}

require("mason").setup()
require("mason-lspconfig").setup{
   ensure_installed = {"lua_ls", "pyright"},
}

require("oil").setup()
require("mini.pick").setup()
