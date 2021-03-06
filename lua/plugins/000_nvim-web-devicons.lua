if vim.api.nvim_call_function('FindPlugin', {'nvim-web-devicons'}) == 0 then do return end end

-- local devicons = require'nvim-web-devicons'

require'nvim-web-devicons'.setup({
  default = true,
  override = {
    ["lir_folder_icon"] = {
      icon = "",
      color = "#7ebae4",
      name = "FolderNode"
    },
    ["vue"] = {
      icon = "󿵂",
      color = "#8dc149",
      name = "Vue"
    },
  }
})
