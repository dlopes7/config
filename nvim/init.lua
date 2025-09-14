vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.g.mapleader = " "
vim.o.winborder = "rounded"

vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>d", ":t.<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope fd<CR>")
vim.keymap.set("n", "<leader>gr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<leader>gd", ":Telescope lsp_definitions<CR>")

vim.pack.add {
	-- lsp
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },

	-- telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-file-browser.nvim" },

	-- theme
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },

	-- Niceties
	{ src = "https://github.com/nvim-mini/mini.nvim" }
}

require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "ruff", "ts_ls", "eslint", "gopls", "pyright" },
}

require("telescope").setup()
require("telescope").load_extension "file_browser"
require("oil").setup()
require("mini.pick").setup()
require("mini.comment").setup()
require("mini.completion").setup()

vim.cmd [[colorscheme tokyonight-night]]

-- autocomplete and lint
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if not client:supports_method('textDocument/willSaveWaitUntil')
		    and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.tsx', '*.ts', '*.cts', '*.jsx', '*.js', '*.cjs' },
	command = 'LspEslintFixAll',
	group = vim.api.nvim_create_augroup('EslintAutoFormat', {})
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.py' },
	callback = function()
		vim.lsp.buf.code_action {
			context = {
				only = { 'source.fixAll' },
				diagnostics = {}
			},
			apply = true,
		}
		vim.lsp.buf.format { async = true }
	end,
	group = vim.api.nvim_create_augroup('RuffAutoFormat', {})
})


vim.keymap.set('n', 'gK', function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })
