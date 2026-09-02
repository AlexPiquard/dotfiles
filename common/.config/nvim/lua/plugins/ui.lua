local incline_separator = " "

return {
	{
		-- buffer name and related info at top right window corner
		-- TODO: show todo-comments
		"b0o/incline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = {
							default = true,
							group = "PmenuThumb",
						},
						InclineNormalNC = {
							default = true,
							group = "PmenuThumb",
						},
					},
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local ft_icon, ft_color = require("mini.icons").get("file", filename)
					local modified = vim.bo[props.buf].modified and "WarningMsg" or ""

					local function get_display_name()
						local buffers = vim.api.nvim_list_bufs()
						for _, buf in ipairs(buffers) do
							if vim.api.nvim_buf_is_loaded(buf) then
								if
									vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t") == filename
									and props.buf ~= buf
								then
									-- show parent in name if other buffers have the same name
									return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":p:h:t")
										.. "/"
										.. filename
								end
							end
						end

						return filename
					end

					local function get_git_diff()
						local icons = { removed = "-", changed = "~", added = "+" }
						local groups = { removed = "GitSignsDelete", changed = "GitSignsChange", added = "GitSignsAdd" }
						local signs = vim.b[props.buf].gitsigns_status_dict
						local labels = {}
						if signs == nil then
							return labels
						end
						for name, icon in pairs(icons) do
							if tonumber(signs[name]) and signs[name] > 0 then
								table.insert(
									labels,
									{ icon .. signs[name] .. " ", group = groups[name], guibg = "none" }
								)
							end
						end
						if #labels > 0 then
							table.insert(labels, { incline_separator })
						end
						return labels
					end

					local function get_diagnostic_label()
						local icons = { error = "󰅙 ", warn = " ", info = "󰋼 ", hint = "󰌵 " }
						local label = {}

						for severity, icon in pairs(icons) do
							local n = #vim.diagnostic.get(
								props.buf,
								{ severity = vim.diagnostic.severity[string.upper(severity)] }
							)
							if n > 0 then
								table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
							end
						end
						if #label > 0 then
							table.insert(label, { incline_separator })
						end
						return label
					end

					return {
						{ get_diagnostic_label() },
						{ get_git_diff() },
						{ (ft_icon or "") .. " ", group = ft_color },
						{ get_display_name() .. " " .. incline_separator, group = modified },
						{
							" " .. vim.api.nvim_win_get_number(props.win),
							group = vim.api.nvim_get_current_win() == props.win and "Character" or "DevIconWindows",
						},
					}
				end,
			})
		end,
	},
	{
		-- native Undotree
		dir = vim.fn.expand("$VIMRUNTIME/pack/dist/opt/nvim.undotree"),
		name = "nvim.undotree",
		cmd = "Undotree",
	},
	{
		-- Faster opening of big files
		"pteroctopus/faster.nvim",
		lazy = false,
		opts = {},
	},
}
