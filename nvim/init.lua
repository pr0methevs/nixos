

vim.cmd("colorscheme gruvbox")

-- Setup Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- 1. Enable the server (this replaces .setup{})
-- The name must match the filename in nvim-lspconfig's lsp/ directory
vim.lsp.enable('nil_ls') 

-- 2. (Optional) Customize the config
-- If you need to pass specific settings (like formatting), use this:
vim.lsp.config('nil_ls', {
  settings = {
    ['nil'] = {
      formatting = { command = { "nixpkgs-fmt" } },
    },
  },
})

-- 3. Modern Keybindings (using the LspAttach autocmd)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Add your keymaps here
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
  end,
})

