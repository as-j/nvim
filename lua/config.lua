-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "💡",
            package_pending = "🥊",
            package_uninstalled = "🤮",
        },
    }
})
require("mason-lspconfig").setup{
    ensure_installed = { "lua_ls", "rust_analyzer", "bashls", "clangd", "dockerls","jsonls" },
}

-- Treesitter Plugin Setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml", "python", "cpp" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fF', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fS', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})
vim.keymap.set('n', '<leader>fl', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>fc', builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>fm', builtin.marks, {})



vim.keymap.set('n', '<leader>n', function() vim.cmd "noh" end, {})

require('telescope').load_extension('git_grep')

-- Search for the current word and fuzzy-search over the result using git_grep.grep().
local gg = require 'git_grep'
vim.keymap.set({'n', 'v'}, '<leader>g', gg.grep, {})
-- Interactively search for a pattern using git_grep.live_grep().
vim.keymap.set('n', '<leader>G', gg.live_grep, {})

vim.cmd([[
set notimeout
set encoding=utf-8
set fenc=utf-8
]])

vim.opt.listchars = {
  tab = ">-",
  eol = '⇠',
  trail = '✚',
  extends = '>',
  precedes = '<',
}


require'neogit'.setup{
    console_timeout = 6000
}

require'lspconfig'.clangd.setup{}
require'lspconfig'.pylsp.setup{}
--require'lspconfig'.bzl.setup{}

--require'lspconfig'.pyright.setup{}

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end
    map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text Object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    vim.cmd[[highlight GitSignsAdd guibg=NONE]]
    vim.cmd[[highlight GitSignsChange guibg=NONE]]
    vim.cmd[[highlight GitSignsDelete guibg=NONE]]

  end,
})

require('gitsigns').setup{
    signs = {
        add          = { text = '+' },
        change       = { text = 'm' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = 'C' },
        untracked    = { text = 'u' },
    }
}
---require("inlay-hints").setup{}
require("clangd_extensions").setup{
    inlay_hints = {
        inline = false,
        only_current_line = false,
        -- prefix for parameter hints
        parameter_hints_prefix = " ◀︎ ",
    }
}

function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^user') and not name:match('nvim-tree') then
      package.loaded[name] = nil
    end
  end

  vim.cmd "source $MYVIMRC"
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end


