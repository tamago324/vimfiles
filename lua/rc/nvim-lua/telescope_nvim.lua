local ok, telescope = pcall(require, 'telescope')
if not ok then do return end end

local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')


-- https://github.com/nvim-lua/telescope.nvim/blob/d32d4a6e0f0c571941f1fd37759ca1ebbdd5f488/lua/telescope/init.lua
telescope.setup{
  defaults = {
    borderchars = {'-', '|', '-', '|', '+', '+', '+', '+'},
    winblend = 30,

    default_mappings = {
      i = {
        ["<C-n>"] = nil,
        ["<C-p>"] = nil,
      },
    },

    mappings = {
      -- insert mode のマッピング
      i = {
        -- 閉じる
        ["<C-c>"] = actions.close,
        ["<C-q>"] = actions.close,

        -- カーソル移動
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        -- 開く
        ["<C-t>"] = actions.goto_file_selection_tabedit,
        ["<C-s>"] = actions.goto_file_selection_split,
        ["<C-v>"] = actions.goto_file_selection_vsplit,
        ["<CR>"]  = actions.goto_file_selection_edit,
      },

      -- normal mode のマッピング
      n = {
        -- カーソル移動
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,

        ["q"] = actions.close,

        -- 開く
        ["<C-t>"] = actions.goto_file_selection_tabedit,
        ["<C-s>"] = actions.goto_file_selection_split,
        ["<C-v>"] = actions.goto_file_selection_vsplit,
        ["<CR>"]  = actions.goto_file_selection_edit,
      },
    },
    color_devicons = true,
    file_sorter = sorters.get_fzy_sorter,
  }
}

local vimp = require('vimp')

-- <Space>fv 設定ファイルを検索
vimp.nnoremap({'override'}, '<Space>fv', function()
  require'telescope.builtin'.find_files{
    cwd = vim.g.vimfiles_path,
    file_ignore_patterns = { "_config/.*" }
  }
end)

-- <Space>f; 履歴検索
vimp.nnoremap({'override'}, '<Space>f;', function()
  require('telescope.builtin').command_history {}
end)

-- <A-x> コマンド検索
vimp.nnoremap({'override'}, '<A-x>', function()
  require('telescope.builtin').commands {}
end)

-- <Space>fh ヘルプ検索
vimp.nnoremap({'override'}, '<Space>fh', function()
  require('telescope.builtin').help_tags {}
end)

-- <Space>fj バッファ検索
vimp.nnoremap({'override'}, '<Space>fj', function()
  require('telescope.builtin').buffers {
    shorten_path = true,
    show_all_buffers = true,
  }
end)

-- <Space>ff ファイル検索
vimp.nnoremap({'override'}, '<Space>ff', function()
  require'telescope.builtin'.git_files{}
end)


-- <Space>ft ファイルタイプ検索
vimp.nnoremap({'override'}, '<Space>ft', function()
  require'vimrc.telescope'.filetypes{}
end)

vimp.cmap({'override'}, '<C-l>', '<Plug>(TelescopeFuzzyCommandSearch)')

-- ghq


-- mru
vimp.nnoremap({'override'}, '<Space>fk', function()
  require('vimrc.telescope').mru{
    shorten_path = true,
  }
end)

-- mrr
vimp.nnoremap({'override'}, '<Space>fp', function()
  require('vimrc.telescope').mrr{}
end)