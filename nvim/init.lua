require 'whatadrag.general'
require 'whatadrag.keymaps'
require 'whatadrag.comment'
require 'whatadrag.plugins'
require 'whatadrag.colorizer'
-- require 'whatadrag.tabbar'
require 'whatadrag.statusbar'
require 'whatadrag.web_devicons'
require 'whatadrag.nvim_tree'
require 'whatadrag.treesitter'
require 'whatadrag.telescope'
require 'whatadrag.coc'
-- require 'whatadrag.indent-blankline'
-- require 'whatadrag.lsp'

-- ╭─────────╮
-- │ autocmd │
-- ╰─────────╯
require 'whatadrag.autocmd'
vim.notify('colorscheme')
require 'whatadrag.colorscheme'

vim.cmd [[
    source ~/.config/nvim/lua/coc.vim
    let g:vimwiki_list = [{'path': '~/Documents/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
]]
