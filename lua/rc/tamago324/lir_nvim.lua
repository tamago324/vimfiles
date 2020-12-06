if vim.api.nvim_call_function('FindPlugin', {'lir.nvim'}) == 0 then do return end end

local lvim = require 'lir.vim'

local actions = require'lir.float.actions'

local function rm()
  local path = lvim.b.context.dir .. lvim.b.context:current()
  local esc_path = vim.fn.shellescape(vim.fn.fnamemodify(path, ':p'), true)
  vim.api.nvim_feedkeys(':!gomi ' .. esc_path, 'n', true)
end

require 'lir'.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['K']     = actions.mkdir,
    ['N']     = actions.newfile,
    ['R']     = actions.rename,
    ['@']     = actions.cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['D']     = rm,
  }
}

require 'lir.float'.setup({
  size_percentage = 0.5,
  winblend = 2,
})