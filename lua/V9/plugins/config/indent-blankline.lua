local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#F38BA8" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#FAB387" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#F9E2AF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#A6E3A1" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#94E2D5" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#89B4FA" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#C6A0F6" })
end)
require("ibl").setup { indent = { highlight = highlight } }
