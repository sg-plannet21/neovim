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

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim whenever you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup(function(use)
    use('wbthomason/packer.nvim')
    
    -- My plugins here
    
    use('bluz71/vim-nightfly-guicolors')
    -- tmux and split window navigator
    use('christoomey/vim-tmux-navigator')
    -- maximises and restores current window
    use('szw/vim-maximizer')

    -- surrounding with ys motion char-to-surround
    use("tpope/vim-surround")
    --use("vim-scripts/ReplaceWithRegister")

    -- commenting with gc
    use("numToStr/Comment.nvim")

    -- statusline
    use("nvim-lualine/lualine.nvim")

    use ({
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'}, { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } }
    })

    use({
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        requires = {
            -- Snippet Engine & its associated nvim-cmp source
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },

            -- Adds LSP completion capabilities
            { 'hrsh7th/cmp-nvim-lsp' },

            -- Adds a number of user-friendly snippets
            { 'rafamadriz/friendly-snippets' },

            -- vs-code like icons for autocompletion
            { "onsails/lspkind.nvim" },

            -- source for text in buffer
            { 'hrsh7th/cmp-buffer' },
            --
            -- source for file system paths
            { 'hrsh7th/cmp-path' },
        },
    })

    -- LSP Plugins
    use({
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        requires = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            {
                "glepnir/lspsaga.nvim",
                branch = "main",
                requires = {
                    { "nvim-tree/nvim-web-devicons" },
                    { "nvim-treesitter/nvim-treesitter" },
                },
            },
            -- additional functionality for typescript server (e.g. rename file & update imports)
            { "jose-elias-alvarez/typescript.nvim" },
            -- vs-code like icons for autocompletion
            { "onsails/lspkind.nvim" },
            -- configure formatters & linters
            { "jose-elias-alvarez/null-ls.nvim" },
            -- bridges gap b/w mason & null-ls
            { "jayp0521/mason-null-ls.nvim" },

             -- formatting & linting
             -- configure formatters & linters
             { "jose-elias-alvarez/null-ls.nvim" },
             -- bridges gap b/w mason & null-ls
             { "jayp0521/mason-null-ls.nvim" }

            -- Additional lua configuration, makes nvim stuff amazing!
            -- { 'folke/neodev.nvim' },
        },
    })

    -- treesitter configuration
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    })

    -- auto closing
    use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
    use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

    -- git integration
    use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
