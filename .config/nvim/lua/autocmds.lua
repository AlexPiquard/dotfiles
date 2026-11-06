-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- disable cursorline highlight on specific buffers
local disable_cursorline_group = vim.api.nvim_create_augroup("DisableCursorline", { clear = true })
local disabled_filetypes = { "opencode_ask" }
local disabled_buftypes = { "terminal", "nofile" }
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = disable_cursorline_group,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local bt = vim.bo[args.buf].buftype

		if vim.tbl_contains(disabled_filetypes, ft) or vim.tbl_contains(disabled_buftypes, bt) then
			vim.opt_local.cursorline = false
		end
	end,
})

-- custom actions available only on the intro buffer
local intro_group = vim.api.nvim_create_augroup("intro_keymaps", { clear = true })
local intro_actions = {
	{
		key = "s",
		desc = "Restore session",
		action = function()
			require("auto-session").restore_session(nil, { show_message = false })
		end,
	},
	{
		key = "L",
		desc = "Lazy",
		action = "<cmd>Lazy<cr>",
	},
}

local function is_intro_buf(buf)
	return vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" and vim.bo[buf].filetype == ""
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = intro_group,
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		if vim.fn.argc() == 0 and is_intro_buf(buf) then
			vim.b[buf].intro = true
			for _, item in ipairs(intro_actions) do
				vim.keymap.set("n", item.key, item.action, { buffer = buf, desc = item.desc })
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufNewFile", "FileType" }, {
	group = intro_group,
	callback = function(args)
		if vim.b[args.buf].intro and not is_intro_buf(args.buf) then
			vim.b[args.buf].intro = nil
			for _, item in ipairs(intro_actions) do
				pcall(vim.keymap.del, "n", item.key, { buffer = args.buf })
			end
		end
	end,
})
