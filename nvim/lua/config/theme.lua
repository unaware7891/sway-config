local theme_file = vim.fn.expand("~/.cache/hellwal/last-theme")

local theme_map = {
  ["catppuccin"]       = "catppuccin",
  ["gruvbox"]          = "gruvbox",
  ["kanagawa"]         = "kanagawa",
  ["tokyo-night"]      = "tokyonight",
  ["everforest"]       = "everforest",
  ["dracula"]          = "dracula",
  ["gruvbox-material"] = "gruvbox-material",
  ["zenbones"]         = "zenbones",
}

local function apply_theme()
  local f = io.open(theme_file, "r")
  if not f then return end

  local theme = f:read("*l")
  f:close()

  local colorscheme = theme_map[theme]
  if not colorscheme then return end

  -- always dark (never light)
  vim.o.background = "dark"

  -- theme-specific config
  if colorscheme == "gruvbox-material" then
    vim.g.gruvbox_material_background = "hard"  -- soft | medium | hard
    vim.g.gruvbox_material_palette = "material" -- material | mix | original
    vim.g.gruvbox_material_foreground = "material"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1
  end

  vim.cmd.colorscheme(colorscheme)
end

apply_theme()

-- allow live reload
vim.api.nvim_create_autocmd("User", {
  pattern = "ThemeChanged",
  callback = apply_theme,
})
