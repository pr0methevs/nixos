vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



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

vim.cmd("colorscheme gruvbox")


-- -- [[ setting options ]]
-- -- see `:help vim.opt`
-- -- note: you can change these options as you wish!
-- --  for more options, you can see `:help option-list`
--
-- -- make line numbers default
-- vim.opt.number = true
-- -- you can also add relative line numbers, to help with jumping.
-- --  experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true
--
-- -- enable mouse mode, can be useful for resizing splits for example!
-- vim.opt.mouse = 'a'
--
-- -- don't show the mode, since it's already in the status line
-- vim.opt.showmode = false
--
-- -- sync clipboard between os and neovim.
-- --  schedule the setting after `uienter` because it can increase startup-time.
-- --  remove this option if you want your os clipboard to remain independent.
-- --  see `:help 'clipboard'`
-- vim.schedule(function()
--     vim.opt.clipboard = 'unnamedplus'
-- end)
--
-- -- enable break indent
-- vim.opt.breakindent = true
--
-- -- save undo history
-- vim.opt.undofile = true
--
-- -- case-insensitive searching unless \c or one or more capital letters in the search term
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
--
-- -- keep signcolumn on by default
-- vim.opt.signcolumn = 'yes'
--
-- -- decrease update time
-- vim.opt.updatetime = 250
--
-- -- decrease mapped sequence wait time
-- -- displays which-key popup sooner
-- vim.opt.timeoutlen = 300
--
-- -- configure how new splits should be opened
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
--
-- -- sets how neovim will display certain whitespace characters in the editor.
-- --  see `:help 'list'`
-- --  and `:help 'listchars'`
-- vim.opt.list = false
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- -- vim.opt.listchars = { trail = '·', nbsp = '␣' }
--
-- -- preview substitutions live, as you type!
-- vim.opt.inccommand = 'split'
--
-- -- show which line your cursor is on
-- vim.opt.cursorline = true
--
-- -- minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10
--
-- vim.opt.tabstop = 4 -- how many spaces a <Tab> visually represents
-- vim.opt.shiftwidth = 4 -- indentation width for >>, <<, ==, autoindent
-- vim.opt.softtabstop = 4 -- how many spaces <Tab>/<BS> use while editing
-- vim.opt.expandtab = true -- insert spaces instead of a real <Tab> char
--
-- -- Per‑filetype
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'yaml' },
--     callback = function()
--         vim.opt_local.tabstop = 2
--         vim.opt_local.shiftwidth = 2
--         vim.opt_local.softtabstop = 2
--         vim.opt_local.expandtab = true
--     end,
-- })
--
require 'options'
