vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Ctrl-L redraws the screen by default. Now it will also toggle search highlighting.
vim.keymap.set('n', '<C-l>', ':set hlsearch!<cr><C-l>', { desc = 'Toggle search highlighting' })

-- Navigate visual lines
vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set('i', '<Down>', '<C-\\><C-o>gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set('i', '<Up>', '<C-\\><C-o>gk', { desc = 'Navigate up (visual line)' })

-- Navigating buffers
vim.keymap.set('n', '<leader>bb', '<C-^>', { desc = 'Switch to alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })

-- 1. Enable the server (this replaces .setup{})
-- The name must match the filename in nvim-lspconfig's lsp/ directory
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
vim.lsp.enable(
    'ansiblels',
    'bashls',
    'docker-language-server',
    'gh_actions',
    'gopls',
    'jdtls',
    'jqls',
    'kotlin_language-server',
    'lua_ls',
    'nil_ls',
    'pyright',
    'rust_analyzer',
    'terraformls',
    'ts_ls',
    'yamlls'
) 

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

vim.cmd("colorscheme gruvbox")

require('options')
