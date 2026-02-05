vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.undofile = true
vim.o.confirm = true

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/Saghen/blink.cmp" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- for telescope
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  -- { src = "https://github.com/nvim-lua/lsp-status.nvim" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
})
require("mini.statusline").setup()
require("fidget").setup({
  -- Options related to LSP progress subsystem
  progress = {
    poll_rate = 0,                -- How and when to poll for progress messages
    suppress_on_insert = false,   -- Suppress new messages while in insert mode
    ignore_done_already = false,  -- Ignore new tasks that are already complete
    ignore_empty_message = false, -- Ignore new tasks that don't contain a message
    clear_on_detach =             -- Clear notification group when LSP server detaches
        function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,
    notification_group = -- How to get a progress message's notification group key
        function(msg) return msg.lsp_client.name end,
    ignore = {},         -- List of LSP servers to ignore

    -- Options related to how LSP progress messages are displayed as notifications
    display = {
      render_limit = 16, -- How many LSP messages to show at once
      done_ttl = 3, -- How long a message should persist after completion
      done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
      done_style = "Constant", -- Highlight group for completed LSP tasks
      progress_ttl = math.huge, -- How long a message should persist when in progress
      progress_icon = -- Icon shown when LSP progress tasks are in progress
      { "dots" },
      progress_style = -- Highlight group for in-progress LSP tasks
      "WarningMsg",
      group_style = "Title", -- Highlight group for group name (LSP server name)
      icon_style = "Question", -- Highlight group for group icons
      priority = 30, -- Ordering priority for LSP notification group
      skip_history = true, -- Whether progress notifications should be omitted from history
      format_message = -- How to format a progress message
          require("fidget.progress.display").default_format_message,
      format_annote = -- How to format a progress annotation
          function(msg) return msg.title end,
      format_group_name = -- How to format a progress notification group's name
          function(group) return tostring(group) end,
      overrides = { -- Override options from the default notification config
        rust_analyzer = { name = "rust-analyzer" },
      },
    },

    -- Options related to Neovim's built-in LSP client
    lsp = {
      progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
      log_handler = false,       -- Log `$/progress` handler invocations (for debugging)
    },
  },

  -- Options related to notification subsystem
  notification = {
    poll_rate = 10,               -- How frequently to update and render notifications
    filter = vim.log.levels.INFO, -- Minimum notifications level
    history_size = 128,           -- Number of removed messages to retain in history
    override_vim_notify = false,  -- Automatically override vim.notify() with Fidget
    configs =                     -- How to configure notification groups when instantiated
    { default = require("fidget.notification").default_config },
    redirect =                    -- Conditionally redirect notifications to another backend
        function(msg, level, opts)
          if opts and opts.on_open then
            return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
          end
        end,

    -- Options related to how notifications are rendered as text
    view = {
      stack_upwards = true,    -- Display notification items from bottom to top
      align = "message",       -- Indent messages longer than a single line
      reflow = false,          -- Reflow (wrap) messages wider than notification window
      icon_separator = " ",    -- Separator between group name and icon
      group_separator = "---", -- Separator between notification groups
      group_separator_hl =     -- Highlight group used for group separator
      "Comment",
      line_margin = 1,         -- Spaces to pad both sides of each non-empty line
      render_message =         -- How to render notification messages
          function(msg, cnt)
            return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
          end,
    },

    -- Options related to the notification window and buffer
    window = {
      normal_hl = "Comment", -- Base highlight group in the notification window
      winblend = 100,        -- Background color opacity in the notification window
      border = "none",       -- Border around the notification window
      zindex = 45,           -- Stacking priority of the notification window
      max_width = 0,         -- Maximum width of the notification window
      max_height = 0,        -- Maximum height of the notification window
      x_padding = 1,         -- Padding from right edge of window boundary
      y_padding = 0,         -- Padding from bottom edge of window boundary
      align = "bottom",      -- How to align the notification window
      relative = "editor",   -- What the notification window position is relative to
      tabstop = 8,           -- Width of each tab character in the notification window
      avoid = {}             -- Filetypes the notification window should avoid
      -- e.g., { "aerial", "NvimTree", "neotest-summary" }
    },
  },

  -- Options related to integrating with other plugins
  integration = {
    ["nvim-tree"] = {
      enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
      -- DEPRECATED; use notification.window.avoid = { "NvimTree" }
    },
    ["xcodebuild-nvim"] = {
      enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
      -- DEPRECATED; use notification.window.avoid = { "TestExplorer" }
    },
  },

  -- Options related to logging
  logger = {
    level = vim.log.levels.WARN, -- Minimum logging level
    max_size = 10000,            -- Maximum log file size, in KB
    float_precision = 0.01,      -- Limit the number of decimals displayed for floats
    path =                       -- Where Fidget writes its logs to
        string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
  },
})

require("blink.cmp").setup({
  fuzzy = {
    implementation = "lua",
  },
  signature = { enabled = true },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 1,
    },
    menu = {
      border = "rounded",
      auto_show = true,
      auto_show_delay_ms = 1,
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon", "label", "label_description", gap = 1 },
          { "kind" } }
      }
    }
  }
})

require "oil".setup({
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})
vim.keymap.set('n', '<leader>e', "<CMD>Oil --float<CR>", { desc = "Open file [E]xplorer" })


vim.lsp.enable({ "lua_ls", "rust_analyzer", "ts_ls", "nixd" })

require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 150,
    },
    menu = {
      auto_show = true
    }
  },
  keymap = {
    preset = "default", -- optional; tab to navigate/confirm
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
  },
})

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Create buffer-local LSP keymaps when a server attaches
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local tb = require('telescope.builtin')

    -- Helper for buffer-local mapping
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = 'LSP: ' .. (desc or '') })
    end

    -- Telescope-powered LSP pickers
    map('n', 'grd', tb.lsp_definitions, '[G]oto [D]efinition')
    map('n', 'gri', tb.lsp_implementations, '[G]oto [I]mplementation')
    map('n', 'grr', tb.lsp_references, '[G]oto [R]eferences')
    map('n', 'grt', tb.lsp_type_definitions, '[G]oto [T]ype Definition')
    map('n', 'gO', tb.lsp_document_symbols, 'Open Document Symbols')
    map('n', 'gW', tb.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    -- Non-Telescope LSP actions if you want
    map('n', 'grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction')
    map('n', 'grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  end,
})

-- Format on save with LSP (async to avoid blocking UI)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  callback = function(args)
    -- Only try if an LSP with formatting is attached
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    local supports = false
    for _, c in ipairs(clients) do
      if c.supports_method and c:supports_method("textDocument/formatting") then
        supports = true
        break
      end
    end
    if supports then
      -- You can pass filter to select a specific client if multiple exist
      vim.lsp.buf.format({
        bufnr = args.buf,
        async = false, -- run before write; set true if you prefer async
        -- filter = function(client) return client.name == "lua_ls" end,
        timeout_ms = 3000,
      })
    end
  end,
})

-- Show diagnostics immediately when moving the cursor
vim.api.nvim_create_autocmd('CursorMoved', {
  callback = function()
    -- Only show if there's a diagnostic at the cursor
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #diagnostics > 0 then
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'if_many',
        scope = 'cursor',
      })
    end
  end,
})

require("floatingterminal")

require("catppuccin").setup({
  flavour = "mocha",
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  float = {
    transparent = false,
    solid = false,
  },
  show_end_of_buffer = false,
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  lsp_styles = {
    virtual_text = {
      errors = { "italic" },
      hints = { "italic" },
      warnings = { "italic" },
      information = { "italic" },
      ok = { "italic" },
    },
    underlines = {
      errors = { "underline" },
      hints = { "underline" },
      warnings = { "underline" },
      information = { "underline" },
      ok = { "underline" },
    },
    inlay_hints = {
      background = true,
    },
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  auto_integrations = false,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
  },
})

vim.cmd.colorscheme "catppuccin"
