if vim.api.nvim_call_function('FindPlugin', {'lir.nvim'}) == 0 then do return end end

local a = vim.api

local lir = require 'lir'
local float = require 'lir.float'
local utils = require 'lir.utils'
local uv = vim.loop


local mmv = require 'lir.mmv.actions'.mmv
local b_actions = require 'lir.bookmark.actions'
local mark_actions = require 'lir.mark.actions'
local mark_utils = require 'lir.mark.utils'
local clipboard_actions = require'lir.clipboard.actions'

local actions = require'lir.actions'

local function esc_path(path)
  return vim.fn.shellescape(vim.fn.fnamemodify(path, ':p'), true)
end

local function feedkeys(key)
  a.nvim_feedkeys(a.nvim_replace_termcodes(key, true, false, true), 'n', true)
end

-- local function cp(context)
--   local path = context.dir .. context:current_value()
--   local cmd = string.format([[:!cp %s %s]], esc_path(path), esc_path(context.dir))
--   a.nvim_feedkeys(cmd, 'n', true)
-- end

local function yank_win_path(context)
  local path = vim.fn.expand(context.dir .. context:current_value())
  local winpath = [[\\wsl$\Ubuntu-18.04]] .. path:gsub('/', '\\')
  vim.fn.setreg(vim.v.register, winpath)
  print('Yank path: ' .. winpath)
end

local function newfile(context)
  local name = vim.fn.input('New file: ', '', 'file')
  if name == '' then
    return
  end

  if name == '.' or name == '..' or string.match(name, '[/\\]') then
    utils.error('Invalid file name: ' .. name)
    return
  end

  local function touch(path)
    local f = uv.fs_open(path, 'w', tonumber('644', 8))
    uv.fs_close(f)
  end
  touch(context.dir .. name)

  actions.reload()

  local lnum = lir.get_context():indexof(name)
  if lnum then
    vim.cmd(tostring(lnum))
  end
end

function cd(context)
  actions.cd(context)
  vim.fn['deol#cd'](context.dir)
end

function rm(context)
  -- 選択されているものを取得する
  local marked_items = mark_utils.get_marked_items(context)
  if #marked_items == 0 then
    -- 選択されていなければ、カレント行を削除
    local path = context.dir .. context:current_value()
    vim.fn.system('gomi ' .. esc_path(path))
    actions.reload()
    return
  end

  local path_list = vim.tbl_map(function(items)
    return esc_path(items.fullpath)
  end, marked_items)
  -- for _, f in ipairs(marked_items) do
  --     -- TODO:
  --     -- 確認する
  --     -- "これ以降、同じ" みたいなこともしたい
  -- end
  if vim.fn.confirm("Delete files?", "&Yes\n&No", 2) == 2 then
    return
  end
  vim.fn.system('gomi ' .. vim.fn.join(path_list))
  actions.reload()
end

function nop()
end


require 'lir'.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    -- ['j'] = function()
    --   if vim.fn.line('.') == vim.fn.line('$') then
    --     feedkeys('gg')
    --   else
    --     feedkeys('j')
    --   end
    -- end,
    --
    -- ['k'] = function()
    --   if vim.fn.line('.') == 1 then
    --     feedkeys('G')
    --   else
    --     feedkeys('k')
    --   end
    -- end,
    --
    ['u']     = nop,
    ['U']     = nop,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['K']     = actions.mkdir,
    ['O']     = newfile,
    ['R']     = actions.rename,
    -- ['C']     = cp,
    ['M']     = mmv,
    ['@']     = cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['D']     = rm,
    ['~']     = function() vim.cmd('edit ' .. vim.fn.expand('$HOME')) end,
    ['W']     = yank_win_path,
    ['B']     = b_actions.list,
    ['ba']    = b_actions.add,

    -- ['u']    = m_actions.mark,
    -- ['U']    = m_actions.unmark,
    ['<Space>'] = mark_actions.toggle_mark,
    ['J'] = function(context)
      mark_actions.toggle_mark(context)
      vim.cmd('normal! j')
    end,
    -- ['K'] = function(context)
    --   mark_actions.toggle_mark(context)
    --   vim.cmd('normal! k')
    -- end,

    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste,
  },
  float = {
    size_percentage = 0.5,
    winblend = 2,
    border = true,
    borderchars = {"-" , "|" , "-" , "|" , "+" , "+" , "+" , "+"},
  },
  hide_cursor = true
}

require'lir.bookmark'.setup {
  bookmark_path = '~/.lir_bookmark',
  mappings = {
    ['l']     = b_actions.edit,
    ['<C-s>'] = b_actions.split,
    ['<C-v>'] = b_actions.vsplit,
    ['<C-t>'] = b_actions.tabedit,
    ['<C-e>'] = b_actions.open_lir,
    ['B']     = b_actions.open_lir,
    ['q']     = b_actions.open_lir,
  }
}

nvim_apply_mappings({
  ['n<C-e>'] = { function()
    local dir = nil
    local bufname = vim.fn.bufname()
    if bufname:match('deol%-edit@') or bufname:match('term://') then
      dir = vim.fn.getcwd()
    end
    require'lir.float'.toggle(dir)
  end },
}, {silent = true; noremap = true})
