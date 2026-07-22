--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

vim.o.winborder = 'rounded'

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'
vim.g.clipboard = 'osc52'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 7

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.laststatus = 3

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

---@param diagnostic vim.Diagnostic?
---@return nil
local function maybe_go_to_diagnostic(diagnostic)
  if diagnostic == nil then
    return
  end
  vim.diagnostic.jump { diagnostic = diagnostic }
  -- vim.diagnostic.open_float()
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  maybe_go_to_diagnostic(vim.diagnostic.get_prev())
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  maybe_go_to_diagnostic(vim.diagnostic.get_next())
end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages in [GL]owing' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Random keymaps
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('x', 'p', [["_dP]])

vim.keymap.set('v', '<leader>y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-l>', '<Right>')

vim.keymap.set('v', '>', '>gv', { desc = 'Indent line' })
vim.keymap.set('v', '<', '<gv', { desc = 'Indent line' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>pv', '<Cmd>Ex<CR>', { desc = 'Go to [P]roject [V]iew' })

-- Navigation on cyrillic layout
vim.opt.langmap =
  'йцукенгшщзхъфывапролджэ\\\\ячсмитьбю.ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;qwertyuiop[]asdfghjkl\\;\'\\\\zxcvbnm\\,./QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>'
vim.api.nvim_set_keymap('c', 'й<CR>', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('c', 'й!<CR>', ':q!<CR>', { noremap = true })
vim.api.nvim_set_keymap('c', 'ч<CR>', ':x<CR>', { noremap = true })
vim.api.nvim_set_keymap('c', 'ц<CR>', ':w<CR>', { noremap = true })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'LunarVim/bigfile.nvim',
    opts = {
      features = {
        'lsp',
        'treesitter',
      },
    },
  },

  {
    'numToStr/Comment.nvim',
    opts = {
      opleader = {
        line = '<leader>/',
        block = '<leader>b/',
      },
      mappings = {
        extra = false,
      },
    },
    config = function(_, opts)
      opts.pre_hook = function(ctx)
        local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
        if ok and parser then
          return nil
        end

        return require('Comment.ft').get(vim.bo.filetype, ctx.ctype)
      end

      require('Comment').setup(opts)
      vim.keymap.set('n', '<leader>/', function()
        require('Comment.api').toggle.linewise.current()
      end, { desc = 'Toggle comment' })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      word_diff = true,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 100,
      },
    },
    config = function(_, opts)
      local gs = require 'gitsigns'
      gs.setup(opts)

      local function map(mode, lhs, rhs, desc)
        local o = {
          desc = desc,
          bufnr = opts.bufnr,
        }
        vim.keymap.set(mode, lhs, rhs, o)
      end

      map('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', '[G]it [P]review hunk')
      map('n', '<leader>gt', ':Gitsigns toggle_current_line_blame<CR>', '[G]it [T]oggle current line blame')
      map('n', '<leader>g]', function()
        if vim.wo.diff then
          vim.cmd.normal { '<leader>g]', bang = true }
        else
          gs.nav_hunk 'next'
        end
      end, '[G]it next hunk')
      map('n', '<leader>g[', function()
        if vim.wo.diff then
          vim.cmd.normal { '<leader>g[', bang = true }
        else
          gs.nav_hunk 'prev'
        end
      end, '[G]it previous hunk')
      map('n', '<leader>gs', gs.stage_hunk, '[G]it [S]tage hunk')
      map('n', '<leader>gr', gs.reset_hunk, '[G]it [R]eset hunk')
      map('n', '<leader>gu', gs.stage_hunk, '[G]it [U]nstage hunk')
      map('n', '<leader>gbl', gs.blame_line, '[G]it [B]lame [L]ine ')
      map('n', '<leader>gbf', gs.blame, '[G]it [B]lame [F]ile')
    end,
  },
  { 'tpope/vim-fugitive' },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
    end,
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        -- { "<leader>c_", hidden = true },
        { '<leader>d', group = '[D]ocument' },
        -- { "<leader>d_", hidden = true },
        { '<leader>r', group = '[R]ename' },
        -- { "<leader>r_", hidden = true },
        { '<leader>s', group = '[S]earch' },
        -- { "<leader>s_", hidden = true },
        { '<leader>w', group = '[W]orkspace' },
        -- { "<leader>w_", hidden = true },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'mrjones2014/smart-splits.nvim',
    opts = {
      multiplexer_integration = 'zellij',
    },
    keys = {
      {
        '<C-h>',
        function()
          require('smart-splits').move_cursor_left()
        end,
        desc = 'Move focus left',
      },
      {
        '<C-j>',
        function()
          require('smart-splits').move_cursor_down()
        end,
        desc = 'Move focus down',
      },
      {
        '<C-k>',
        function()
          require('smart-splits').move_cursor_up()
        end,
        desc = 'Move focus up',
      },
      {
        '<C-l>',
        function()
          require('smart-splits').move_cursor_right()
        end,
        desc = 'Move focus right',
      },
      {
        '<C-\\>',
        function()
          require('smart-splits').move_cursor_previous()
        end,
        desc = 'Move focus previous',
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Search [P]roject [F]iles by name' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>ls', builtin.live_grep, { desc = 'Search by Grep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>of', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>bs', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Fuzzily [s]earch in current [b]uffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>os', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch in [O]pen Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- NOTE: Mason must be loaded before its dependents so we need to set it up here.
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          vim.lsp.inlay_hint.enable(true, { 0 })

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local telescope = require 'telescope.builtin'

          --  To jump back, press <C-t>.
          map('gd', telescope.lsp_definitions, '[G]oto [D]efinition')

          map('gr', telescope.lsp_references, '[G]oto [R]eferences')

          map('<leader>f', vim.lsp.buf.format, '[F]ormat code in the current buffer')

          map('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under the cursor.
          map('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          dont_manage = true,
          cmd = { 'clangd', '--background-index', '-j=16', '--header-insertion=never' },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        },
        rust_analyzer = {
          ignore = true,
        },

        hls = {
          dont_manage = true,
          cmd = { 'haskell-language-server-wrapper', '--lsp' },
          filetypes = { 'haskell' },
        },

        pylsp = {
          ignore = true,
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  ignore = { 'E501' },
                },
              },
            },
          },
        },

        pyrefly = {},

        -- Nix formatter
        alejandra = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- Ignores Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        -- Used to format Lua code
        stylua = {},

        flix = {
          dont_manage = true,
          cmd = { 'flix', 'lsp' },
          filetypes = { 'flix' },
          root_markers = { 'flix.toml' },
        },
      }

      local ensure_installed = {}
      local externally_managed = {}
      local ignored = {}

      for server, cfg in pairs(servers) do
        if cfg.ignore then
          table.insert(ignored, server)
        else
          vim.lsp.config(server, vim.tbl_deep_extend('force', { capabilities = capabilities }, cfg))
          if cfg.dont_manage then
            table.insert(externally_managed, server)
            table.insert(ignored, server)
          else
            table.insert(ensure_installed, server)
          end
        end
      end

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for server, cfg in pairs(servers) do
        if not cfg.ignore then
          vim.lsp.config(server, vim.tbl_deep_extend('force', { capabilities = capabilities }, cfg))
        end
      end

      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (we populate installs via mason-tool-installer)
        automatic_enable = { exclude = ignored },
      }

      local exepath = vim.fn.exepath
      for _, server in pairs(externally_managed) do
        local server_config = servers[server]
        local exe = nil
        if server_config.cmd then
          exe = exepath(server_config.cmd[1])
        else
          exe = exepath(server)
        end
        if exe == '' then
          vim.notify(server .. " not found in $PATH – make sure it's installed", vim.log.levels.ERROR)
          goto continue
        end

        vim.lsp.config(server, servers[server])
        vim.lsp.enable(server)

        ::continue::
      end
    end,
  },

  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        lightbulb = { enable = false },
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, python = true, cmake = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<Tab>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    --   'folke/tokyonight.nvim',
    -- 'cocopon/iceberg.vim',
    -- 'rose-pine/neovim',
    -- name = 'rose-pine',
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      flavour = 'auto',
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      dim_inactive = {
        enabled = true,
      },
      auto_integrations = true,
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin-nvim'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- signs = false,
      highlight = {
        keyword = 'bg',
        before = '',
        after = 'fg',

        pattern = {
          [[.*<(KEYWORDS)\s*[(][^)]*[)]\s*:]], -- TODO (name):
          [[.*<(KEYWORDS)\s*:]], -- TODO:
        },
      },
      search = {
        pattern = [[\b(KEYWORDS)(?:\([^)]*\))?:]],
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        mappings = {
          delete = 'ds',
          replace = 'cs',
        },
        n_lines = 400,
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local parsers = { 'bash', 'c', 'html', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      local indent_filetypes = {
        bash = true,
        c = true,
        go = true,
        html = true,
        lua = true,
        markdown = true,
        query = true,
        vim = true,
      }
      local nvim_treesitter = require 'nvim-treesitter'
      local available_parsers = {}
      local pending_installs = {}

      local function ensure_compiler_flag(env_name, flag)
        local value = vim.env[env_name]
        if value == nil or value == '' then
          vim.env[env_name] = flag
          return
        end

        if not value:find(flag, 1, true) then
          vim.env[env_name] = value .. ' ' .. flag
        end
      end

      nvim_treesitter.setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      ensure_compiler_flag('CFLAGS', '-fPIC')
      ensure_compiler_flag('CXXFLAGS', '-fPIC')

      for _, parser in ipairs(nvim_treesitter.get_available()) do
        available_parsers[parser] = true
      end

      local function has_parser(parser)
        return #vim.api.nvim_get_runtime_file(('parser/%s.*'):format(parser), true) > 0
      end

      local function maybe_enable_treesitter(bufnr, parser)
        if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
          return
        end

        local current_filetype = vim.bo[bufnr].filetype
        if current_filetype == '' then
          return
        end

        local current_parser = vim.treesitter.language.get_lang(current_filetype) or current_filetype
        if parser ~= nil and current_parser ~= parser then
          return
        end

        pcall(vim.treesitter.start, bufnr)

        if indent_filetypes[current_filetype] then
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local function ensure_parser_for_buffer(bufnr, filetype)
        if filetype == '' then
          return
        end

        local parser = vim.treesitter.language.get_lang(filetype) or filetype
        if not available_parsers[parser] then
          maybe_enable_treesitter(bufnr, parser)
          return
        end

        if has_parser(parser) then
          maybe_enable_treesitter(bufnr, parser)
          return
        end

        if pending_installs[parser] == nil then
          pending_installs[parser] = nvim_treesitter.install(parser, { summary = true })
          pending_installs[parser]:await(function(err)
            pending_installs[parser] = nil
            if err then
              return
            end

            vim.schedule(function()
              maybe_enable_treesitter(bufnr, parser)
            end)
          end)
        else
          pending_installs[parser]:await(function(err)
            if err then
              return
            end

            vim.schedule(function()
              maybe_enable_treesitter(bufnr, parser)
            end)
          end)
        end
      end

      local installed = {}
      for _, parser in ipairs(nvim_treesitter.get_installed()) do
        installed[parser] = true
      end

      local missing = {}
      for _, parser in ipairs(parsers) do
        if not installed[parser] then
          table.insert(missing, parser)
        end
      end

      if #missing > 0 then
        nvim_treesitter.install(missing, { summary = true })
      end

      vim.treesitter.language.register('vimdoc', 'help')

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(event)
          ensure_parser_for_buffer(event.buf, event.match)
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 10,
      }
      vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = 'Grey' })
      vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', { underline = true, sp = 'Grey' })
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      -- NOTE: Mason must be loaded before its dependents so we need to set it up here.
      { 'mason-org/mason.nvim', opts = {} },
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,

        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
        },
      }

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup()
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      scope = {
        exclude = {
          language = {},
          node_type = {},
        },
        include = {
          node_type = {},
        },
      },
    },
    config = function(_, opts)
      require('ibl').setup(opts)
      local scope = require 'ibl.scope'
      local scope_languages = require 'ibl.scope_languages'

      local function get_current_scope(bufnr)
        local ok, lang_tree = pcall(vim.treesitter.get_parser, bufnr)
        if not ok or not lang_tree then
          return nil
        end

        local config = require('ibl.config').get_config(bufnr)
        local range = scope.get_cursor_range(0)
        lang_tree = scope.language_for_range(lang_tree, range, config)
        if not lang_tree then
          return nil
        end

        local lang = lang_tree:lang()
        local include_node_types = vim.list_extend(vim.deepcopy(config.scope.include.node_type['*'] or {}), config.scope.include.node_type[lang] or {})
        if not scope_languages[lang] and not vim.tbl_contains(include_node_types, '*') and vim.tbl_isempty(include_node_types) then
          return nil
        end

        local root = lang_tree:parse()[1]:root()
        local node = root:named_descendant_for_range(unpack(range))
        local excluded_node_types = vim.list_extend(vim.deepcopy(config.scope.exclude.node_type['*'] or {}), config.scope.exclude.node_type[lang] or {})

        while node and node:byte_length() > 0 do
          local node_type = node:type()
          if
            ((scope_languages[lang] and scope_languages[lang][node_type]) and not vim.tbl_contains(excluded_node_types, node_type))
            or vim.tbl_contains(include_node_types, node_type)
            or vim.tbl_contains(include_node_types, '*')
          then
            return node
          end

          node = node:parent()
        end

        return nil
      end

      vim.keymap.set('n', '<leader>cc', function()
        local node = get_current_scope(vim.api.nvim_get_current_buf())

        local row = nil
        if node then
          local start_row, _, end_row, _ = node:range()
          if start_row ~= end_row then
            row = start_row + 1
          end
        end
        if row ~= nil then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row, 0 })
          vim.api.nvim_feedkeys('_', 'n', true)
        end
      end, { desc = 'Go to [C]urrent [C]ontext' })
    end,
  },
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup {
        ignore = {
          buftype = { 'quickfix', 'terminal' },
        },
      }
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          settings = {
            ['rust-analyzer'] = {
              -- procMacro = {
              --   ignored = {
              --     leptos_macro = {
              --       -- optional: --
              --       'component',
              --       'server',
              --     },
              --   },
              -- },
              cargo = {
                allFeatures = true,
                buildScripts = {
                  enable = true,
                },
              },
              rustc = {
                source = 'discover',
              },
            },
          },
        },
      }
    end,
  },

  {
    'saecki/crates.nvim',
    ft = { 'toml' },
    tag = 'stable',
    config = function()
      require('crates').setup {
        completion = {
          cmp = {
            enabled = true,
          },
        },
      }
      require('cmp').setup.buffer {
        sources = { { name = 'crates' } },
      }
    end,
  },

  {
    'hiphish/rainbow-delimiters.nvim',
    config = function()
      local self = require 'rainbow-delimiters'

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = self.strategy['global'],
          vim = self.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },
  {
    'eandrju/cellular-automaton.nvim',
    config = function()
      vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>')
    end,
  },
  {
    ---@module "snacks"
    'folke/snacks.nvim',
    opts = {
      input = {
        enabled = true,
      },
      styles = {
        input = {
          relative = 'cursor',
          row = -3,
          col = 0,
        },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown' },
    },
    ft = { 'markdown' },
  },

  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      local supermaven_log = require 'supermaven-nvim.logger'
      local warn = supermaven_log.warn

      supermaven_log.warn = function(self, msg)
        if msg == 'File is too large to send to server. Skipping...' then
          return
        end

        return warn(self, msg)
      end

      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<S-Tab>',
        },
      }
    end,
  },

  {
    'linrongbin16/gitlinker.nvim',
    opts = function()
      local routers = require 'gitlinker.routers'
      local custom_glab_pattern = '^gitlab%..*$'

      return {
        router = {
          browse = {
            [custom_glab_pattern] = routers.gitlab_browse,
          },
          blame = {
            [custom_glab_pattern] = routers.gitlab_blame,
          },
        },
      }
    end,
    keys = {
      {
        '<leader>cpl',
        '<cmd>GitLink<cr>',
        mode = { 'n', 'v' },
        desc = 'Copy git permalink',
      },
      {
        '<leader>cupl',
        '<cmd>GitLink remote=upstream<cr>',
        mode = { 'n', 'v' },
        desc = "Copy git permalink for 'upstream' remote",
      },
    },
  },

  {
    'andymass/vim-matchup',
    ---@type matchup.Config
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },

  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    dependencies = {
      'nvim-telescope/telescope.nvim', -- for Lean-specific pickers
      'andymass/vim-matchup', -- for enhanced % motion behavior
      -- 'andrewradev/switch.vim',        -- for switch support
    },

    ---@type lean.Config
    opts = {
      mappings = true,
    },
  },

  { 'saghen/blink.lib' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  lockfile = vim.fn.stdpath 'state' .. '/lazy-lock.json',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
