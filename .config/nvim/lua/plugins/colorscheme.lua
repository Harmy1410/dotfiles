local transparent = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

local theme = function()
    vim.cmd.colorscheme("vscode")
    require("vscode").setup({
        transparent = true,
        italic_comments = true,
    })
    -- require("gruvbox").setup({
    --     contrast = "hard", -- can be "hard", "soft" or empty string
    --     palette_overrides = {},
    --     overrides = {},
    --     dim_inactive = false,
    --     transparent_mode = true,
    -- })
    transparent()
end

return {
    -- "catppuccin/nvim",
    -- name = "catppuccin",
    "Mofiqul/vscode.nvim",
    -- "ellisonleao/gruvbox.nvim",
    priority = 4,
    -- init = theme,
    config = theme,
}
