--- nvim_apply_mappings
-- From nvim_utils
LUA_BUFFER_MAPPING = {}
LUA_MAPPING = {}

local function escape_keymap(key)
  -- Prepend with a letter so it can be used as a dictionary key
  return 'k'..key:gsub('.', string.byte)
end

local valid_modes = {
  n = 'n'; v = 'v'; x = 'x'; i = 'i';
  o = 'o'; t = 't'; c = 'c'; s = 's';
  -- :map! and :map
  ['!'] = '!'; [' '] = '';
}

function _G.nvim_apply_mappings(mappings, default_options)
  -- May or may not be used.
  local current_bufnr = vim.api.nvim_get_current_buf()
  for key, options in pairs(mappings) do
    options = vim.tbl_extend("keep", options, default_options or {})
    local bufnr = current_bufnr
    -- TODO allow passing bufnr through options.buffer?
    -- protect against specifying 0, since it denotes current buffer in api by convention
    if type(options.buffer) == 'number' and options.buffer ~= 0 then
      bufnr = options.buffer
    end
    local mode, mapping = key:match("^(.)(.+)$")
    if not mode then
      assert(false, "nvim_apply_mappings: invalid mode specified for keymapping "..key)
    end
    if not valid_modes[mode] then
      assert(false, "nvim_apply_mappings: invalid mode specified for keymapping. mode="..mode)
    end
    mode = valid_modes[mode]
    local rhs = options[1]
    -- Remove this because we're going to pass it straight to nvim_set_keymap
    options[1] = nil
    if type(rhs) == 'function' then
      -- Use a value that won't be misinterpreted below since special keys
      -- like <CR> can be in key, and escaping those isn't easy.
      local escaped = escape_keymap(key)
      local key_mapping
      if options.dot_repeat then
        local key_function = rhs
        rhs = function()
          key_function()
          -- -- local repeat_expr = key_mapping
          -- local repeat_expr = mapping
          -- repeat_expr = vim.api.nvim_replace_termcodes(repeat_expr, true, true, true)
          -- nvim.fn["repeat#set"](repeat_expr, nvim.v.count)
          nvim.fn["repeat#set"](nvim.replace_termcodes(key_mapping, true, true, true), nvim.v.count)
        end
        options.dot_repeat = nil
      end
      if options.buffer then
        -- Initialize and establish cleanup
        if not LUA_BUFFER_MAPPING[bufnr] then
          LUA_BUFFER_MAPPING[bufnr] = {}
          -- Clean up our resources.
          vim.api.nvim_buf_attach(bufnr, false, {
            on_detach = function()
              LUA_BUFFER_MAPPING[bufnr] = nil
            end
          })
        end
        LUA_BUFFER_MAPPING[bufnr][escaped] = rhs
        -- TODO HACK figure out why <Cmd> doesn't work in visual mode.
        if mode == "x" or mode == "v" then
          key_mapping = (":<C-u>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(bufnr, escaped)
        else
          key_mapping = ("<Cmd>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(bufnr, escaped)
        end
      else
        LUA_MAPPING[escaped] = rhs
        -- TODO HACK figure out why <Cmd> doesn't work in visual mode.
        if mode == "x" or mode == "v" then
          key_mapping = (":<C-u>lua LUA_MAPPING.%s()<CR>"):format(escaped)
        else
          key_mapping = ("<Cmd>lua LUA_MAPPING.%s()<CR>"):format(escaped)
        end
      end
      rhs = key_mapping
      options.noremap = true
      options.silent = true
    end
    if options.buffer then
      options.buffer = nil
      vim.api.nvim_buf_set_keymap(bufnr, mode, mapping, rhs, options)
    else
      vim.api.nvim_set_keymap(mode, mapping, rhs, options)
    end
  end
end
