-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use "sindrets/diffview.nvim"

    use 'simrat39/rust-tools.nvim'

    -- Completion framework:
    use 'hrsh7th/nvim-cmp'

    -- LSP completion source:
    use 'hrsh7th/cmp-nvim-lsp'

--    use {'neoclide/coc.nvim', branch = 'release'}

    -- Useful completion sources:
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/vim-vsnip'

    use 'nvim-treesitter/nvim-treesitter'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = {
            { "nvim-telescope/telescope-live-grep-args.nvim" },
            {'nvim-lua/plenary.nvim'} },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    }
    use({"davvid/telescope-git-grep.nvim", branch = "main"})

    use { 'NeogitOrg/neogit', requires = 'nvim-lua/plenary.nvim' }

    use 'feline-nvim/feline.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'simrat39/inlay-hints.nvim'
    use 'p00f/clangd_extensions.nvim'

    --use 'f-person/git-blame.nvim'
    --use 'rhysd/git-messenger.vim'
    if packer_bootstrap then
        require('packer').sync()
    end

    use 'skywind3000/asyncrun.vim'

end)
