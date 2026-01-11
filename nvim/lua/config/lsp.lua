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

-- 1. Initialize the plugin FIRST
-- This populates the default settings (like 'code_style') so the theme doesn't crash.
-- require('neomodern').setup({
--   -- You can add custom settings here if you want, 
--   -- but an empty table {} is enough to fix the crash.
--   style = "hojicha", 
-- })
--
-- -- 2. Then load the colorscheme
-- vim.cmd.colorscheme "hojicha"


-- Telescope Keymaps
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Treesitter
-- IMPORTANT: We disable auto_install because Nix manages the grammars!
require('nvim-treesitter.configs').setup {
  auto_install = false, 
  highlight = { enable = true },
  indent = { enable = true },
}

-- ==========================================================================
-- 3. LSP SETUP (The "No-Mason" Way)
-- ==========================================================================
-- Capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = vim.lsp.config

-- Helper function to attach LSPs
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
end

-- ENABLE SERVERS
-- These binaries must be in `extraPackages` in your home.nix!
local servers = { 'lua_ls', 'nixd', 'ts_ls' }

for _, server in ipairs(servers) do
  -- lspconfig[lsp].setup {
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Special setup for Lua to recognize the `vim` global
-- lspconfig.lua_ls.setup {
vim.lsp.config(lua_ls, {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

