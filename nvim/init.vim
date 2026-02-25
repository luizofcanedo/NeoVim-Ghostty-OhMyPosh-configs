" 1. Core Settings
filetype plugin indent on
set number
set relativenumber
set scrolloff=10
set termguicolors
syntax on
set fillchars=eob:\ ,
set pumheight=5

" 2. Cursorline settings
set cursorline
highlight CursorLine cterm=NONE ctermbg=237 guibg=#2b2b2b " Adwaita dark grey
highlight CursorLineNR cterm=bold ctermfg=white

" 3. Plugins
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'branch': 'master', 'do': ':TSUpdate'}
  Plug 'Mofiqul/adwaita.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'L3MON4D3/LuaSnip'
call plug#end()

" 4. Nvim-Tree Configuration
nnoremap <C-n> :NvimTreeToggle<CR>

" 5. Navigation Shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 6. The Master Lua Block
lua << EOF
-- Autocomplete Setup
local cmp = require('cmp')

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger dropdown
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Hit Enter to select
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Pull suggestions from Pyright
  })
})

-- Connect Pyright to the autocomplete engine
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('pyright', {
  capabilities = capabilities,
})
vim.lsp.enable('pyright')

-- Adwaita Theme Setup
vim.g.adwaita_darker = true
vim.g.adwaita_transparent = true 
vim.cmd('colorscheme adwaita')

-- Sidebar Setup
require('nvim-tree').setup()

-- Lualine Setup
require('lualine').setup {
  options = {
    theme = 'adwaita', 
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  }
}

-- Treesitter (The PyCharm Color Engine)
require('nvim-treesitter.configs').setup {
ensure_installed = { "python", "lua", "vim", "vimdoc" },
highlight = { enable = true },
}
EOF

" 7. STRICT TRANSPARENCY ENFORCEMENT
" This MUST go at the very bottom so the theme doesn't overwrite it!
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE ctermfg=grey
highlight SignColumn guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight NvimTreeNormal guibg=NONE ctermbg=NONE
highlight NvimTreeEndOfBuffer guibg=NONE ctermbg=NONE
highlight NvimTreeNormalNC guibg=NONE ctermbg=NONE
highlight! Comment guifg=#a9ffb4 gui=italic cterm=italic
highlight! @comment guifg=#a9ffb4 gui=italic cterm=italic

iabbrev === # ======================================================
