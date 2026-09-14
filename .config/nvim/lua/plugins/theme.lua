local function set_theme(name)
	vim.cmd("colorscheme " .. name)
end

-- Background styles for floats and sidebars. Can be "dark", "transparent" or "normal"
local bg_styles = "dark"

local function derive_colors(colors)
	local Util = require("tokyonight.util")
	colors.diff = {
		add = Util.blend_bg(colors.green2, 0.25),
		delete = Util.blend_bg(colors.red1, 0.25),
		change = Util.blend_bg(colors.blue7, 0.15),
		text = colors.blue7,
	}
	colors.git.ignore = colors.dark3
	colors.black = Util.blend_bg(colors.bg, 0.8, "#000000")
	colors.border_highlight = Util.blend_bg(colors.blue1, 0.8)
	colors.border = colors.black
	colors.bg_popup = colors.bg_dark
	colors.bg_statusline = colors.bg_dark
	colors.bg_sidebar = bg_styles == "transparent" and colors.none
		or bg_styles == "dark" and colors.bg_dark
		or colors.bg
	colors.bg_float = bg_styles == "transparent" and colors.none or bg_styles == "dark" and colors.bg_dark or colors.bg
	colors.bg_visual = Util.blend_bg(colors.blue0, 0.4)
	colors.bg_search = colors.blue0
	colors.fg_sidebar = colors.fg_dark
	colors.fg_float = colors.fg
	colors.error = colors.red1
	colors.todo = colors.blue
	colors.warning = colors.yellow
	colors.info = colors.blue2
	colors.hint = colors.teal
	colors.rainbow = {
		colors.blue,
		colors.yellow,
		colors.green,
		colors.teal,
		colors.magenta,
		colors.purple,
		colors.orange,
		colors.red,
	}

	return colors
end

-- dark theme colors:
-- bg = "#222436",
-- bg_dark = "#1e2030",
-- bg_dark1 = "#191B29",
-- bg_highlight = "#2f334d",
-- blue = "#82aaff",
-- blue0 = "#3e68d7",
-- blue1 = "#65bcff",
-- blue2 = "#0db9d7",
-- blue5 = "#89ddff",
-- blue6 = "#b4f9f8",
-- blue7 = "#394b70",
-- comment = "#636da6",
-- cyan = "#86e1fc",
-- dark3 = "#545c7e",
-- dark5 = "#737aa2",
-- fg = "#c8d3f5",
-- fg_dark = "#828bb8",
-- fg_gutter = "#3b4261",
-- green = "#c3e88d",
-- green1 = "#4fd6be",
-- green2 = "#41a6b5",
-- magenta = "#c099ff",
-- magenta2 = "#ff007c",
-- orange = "#ff966c",
-- purple = "#fca7ea",
-- red = "#ff757f",
-- red1 = "#c53b53",
-- teal = "#4fd6be",
-- terminal_black = "#444a73",
-- yellow = "#ffc777",
-- git = {
--   add = "#b8db87",
--   change = "#7ca1f2",
--   delete = "#e26a75",
-- },

-- light theme colors:
-- bg = "#e1e2e7", (using the night version instead of #d3d4e0)
-- bg_dark = "#d0d5e3", (using the night version instead of #c3c8da)
-- bg_dark1 = "#c1c9df", (using the night version instead of #b5bed5)
-- bg_highlight = "#c4c8da", (using the night version instead of #bdc0d5)
-- blue = "#0078e9",
-- blue0 = "#5679e4",
-- blue1 = "#007ab4",
-- blue2 = "#07879d",
-- blue5 = "#006a83",
-- blue6 = "#2e5857",
-- blue7 = "#92a6d5",
-- comment = "#727ab0",
-- cyan = "#18687a",
-- dark3 = "#8990b3",
-- dark5 = "#68709a",
-- fg = "#365fa6",
-- fg_dark = "#555f8d",
-- fg_gutter = "#a8aecb",
-- git = {
--   add = "#57683e",
--   change = "#3a7ee4",
--   delete = "#a83643"
-- },
-- green = "#506138",
-- green1 = "#287769",
-- green2 = "#38919f",
-- magenta = "#9f46ff",
-- magenta2 = "#d20065",
-- orange = "#bf5700",
-- purple = "#be19a7",
-- red = "#ff053b",
-- red1 = "#e34561",
-- teal = "#287769",
-- terminal_black = "#9ea2c5",
-- yellow = "#815b00"

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			light_style = "moon",
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = bg_styles,
				floats = bg_styles,
			},

			on_highlights = function(hl, c)
				-- Fyler git colors
				hl.FylerGitModified = { fg = c.git.change }
				hl.FylerGitUntracked = { fg = c.git.add }
				-- TabLine
				hl.TabLine = { fg = c.fg_dark, bg = c.bg_statusline }
				hl.TabLineSel = { fg = c.blue, bg = c.fg_gutter }
				hl.TabLineFill = { fg = c.fg_sidebar, bg = c.bg }
				-- Flash
				hl.FlashLabel = { fg = c.bg, bg = "#d20065" }
			end,
			on_colors = function(colors)
				if vim.o.background == "light" then
					colors.bg = "#e1e2e7"
					colors.bg_dark = "#d0d5e3"
					colors.bg_dark1 = "#c1c9df"
					colors.bg_highlight = "#c4c8da"

					colors = derive_colors(colors)
				end
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			local auto_dark_mode = require("lazy.core.config").plugins["auto-dark-mode.nvim"]
			local auto_dark_mode_enabled = auto_dark_mode and auto_dark_mode._.cond
			if not auto_dark_mode_enabled then
				vim.cmd("colorscheme tokyonight")
			end
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 999,
		cond = function()
			local cmd =
				"dbus-send --session --print-reply=literal --reply-timeout=1000 --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:org.freedesktop.appearance string:color-scheme"

			local result = vim.fn.system(cmd)
			return result:match("uint32%s+1") or result:match("uint32%s+[02]")
		end,
		opts = {
			set_dark_mode = function()
				set_theme("tokyonight-moon")
			end,
			set_light_mode = function()
				set_theme("tokyonight-day")
			end,
			update_interval = 1000,
		},
	},
}
