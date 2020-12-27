if vim.api.nvim_call_function('FindPlugin', {'nvim-lspconfig'}) == 0 then do return end end

local neorocks = require'plenary.neorocks'

-- 診断結果の設定
--   LSP の仕様: https://github.com/tennashi/lsp_spec_ja#publishdiagnostics-notification
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- INSERT モードのときは、更新しない
    update_in_insert = false,
    -- 下線を引く
    underline = true,
    virtual_text = false,
    -- virtual_text = {
    --   prefix = '',
    --   spacing = 4
    -- },
  }
)
local mappings = {
  ['n<A-j>'] = {':<C-u>lua vim.lsp.diagnostic.goto_next()<CR>'},
  ['n<A-k>'] ={ ':<C-u>lua vim.lsp.diagnostic.goto_prev()<CR>'},
}
nvim_apply_mappings(mappings, {silent = true, noremap = true})

--[[
  lsp-status
]]
local lsp_status = require('lsp-status')
lsp_status.config {
  -- kind_labels = vim.g.completion_customize_lsp_label,
  -- indicator_info = '',
  -- status_symbol = ''
}
lsp_status.register_progress()


-- =================
-- progress messages
-- =================

-- From: https://github.com/nvim-lua/lsp-status.nvim/blob/0a272e823e30b55aa559a89baa0d9f3197502e4e/lua/lsp-status/statusline.lua#L46-L81
-- LSP の仕様: https://github.com/tennashi/lsp_spec_ja#work-done-progress
-- 以下の部分で処理している
--  https://github.com/nvim-lua/lsp-status.nvim/blob/0a272e823e30b55aa559a89baa0d9f3197502e4e/lua/lsp-status/messaging.lua#L13-L47
local messages = require('lsp-status/messaging').messages
local spinners = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }
local lsp_progress_messages = function()
  local msgs = {}
  local buf_messages = messages()
  for _, msg in ipairs(buf_messages) do
    local name = msg.name
    local client_name = '[' .. name .. ']'
    local contents = ''

    if msg.progress then
      -- 読込中の場合
      contents = msg.title
      if msg.message then
        contents = contents .. ' ' .. msg.message
      end

      if msg.percentage then
        contents = contents .. ' (' .. msg.percentage .. ')'
      end

      if msg.spinner then
        contents = spinners[(msg.spinner % #spinners) + 1] .. ' ' .. contents
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)
  end

  return table.concat(msgs, ' ')
end

---------------------


local on_attach = function(client)
  local mappings = {
    -- ['n<C-]>'] = {'<cmd>lua vim.lsp.buf.definition()<CR>'}
    ['nK'] = {':lua vim.lsp.buf.hover()<CR>'}
  }
  nvim_apply_mappings(mappings, {buffer = true})
  lsp_status.on_attach(client)
end

local lspconfig = require'lspconfig'

--[[
  lua
  cmd のデフォルト値はないため、:LspInstallInfo で確認する
]]

-- -- 参考になる
-- --    https://github.com/7415963987456321/dotfiles/blob/76685865c9ed6d7bb42dda926f21b8cc56201e1e/.config/nvim/lua/init.lua#L71
-- --    https://github.com/tami5/nvim/blob/664e43360cc47e0db8ef9b497ea0dd9381bfa8cb/fnl/module/nvim_lsp.fnl
-- lspconfig.sumneko_lua.setup{
--   on_attach = on_attach,
--   cmd = {
--     "/home/tamago324/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/Linux/lua-language-server",
--     "-E",
--     "/home/tamago324/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua"
--   },
--   settings = {
--     Lua = {
--       runtime = {
--         version = 'LuaJIT',
--       },
--       diagnostics = {
--         enable = true,
--         globals = {'vim', 'describe', 'it', 'before_earch', 'after_each', 'vimp', '_vimp'},
--         disable = {"unused-local", "unused-vararg", "lowercase-global"}
--       },
--       workspace = {
--         -- library = {
--         --   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--         --   [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--         -- }
--         library = {
--           [vim.fn.expand("$VIMRUNTIME")] = true,
--           [vim.fn.stdpath("config")] = true,
--           -- ["/home/tamago324/.cache/nvim/plenary_hererocks/2.1.0-beta3"] = true,
--           -- neorocks のライブラリを追加
--           [neorocks._hererocks_install_location.filename .. '/share/lua/' .. neorocks._lua_version.lua] = true
--         }
--       }
--     }
--   }
-- }

-- see https://github.com/tjdevries/nlua.nvim/blob/master/lua/nlua/lsp/nvim.lua
require('nlua.lsp.nvim').setup(lspconfig, {
  on_attach = on_attach,
  disabled_diagnostics = {"unused-local", "unused-vararg", "lowercase-global"},
  globals = {"pprint"},
  library = {
    -- 再帰的に検索される
    [vim.fn.stdpath("config")] = true,
    [vim.fn.expand("$VIMRUNTIME")] = true,
    -- neorocks のライブラリを追加
    -- ["/home/tamago324/.cache/nvim/plenary_hererocks/2.1.0-beta3"] = true,
    [neorocks._hererocks_install_location.filename .. '/share/lua/' .. neorocks._lua_version.lua] = true
  }
})


--- vim
lspconfig.vimls.setup{
  on_attach = on_attach,
}


-- --- clangd
-- -- install https://clangd.llvm.org/installation.html
-- -- sudo apt-get install clangd-9
-- -- sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100
lspconfig.clangd.setup {
  on_attach = on_attach,
}


-- --[[
--   lsp_ext
-- ]]
-- require'lsp_ext'.set_signature_help_autocmd()


--- rust_analyzer
lspconfig.rust_analyzer.setup{
  on_attach = on_attach,
}

--- pyls
lspconfig.pyls.setup{
  on_attach = on_attach,
}

-- --- efm-langserver
-- -- go get github.com/mattn/efm-langserver
-- require'lspconfig'.efm.setup{}


return {
  lsp_progress_messages = lsp_progress_messages
}
