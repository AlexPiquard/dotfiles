local function default_picker_height()
	local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
	local max_height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (vim.o.laststatus > 0 and 1 or 0)
	return math.floor(0.618 * max_height)
end

local picker_main_heights = {}

local function picker_height()
	local pick = require("mini.pick")
	local state = pick.get_picker_state()
	if state == nil then
		return nil
	end
	local win = state.windows.main
	if vim.api.nvim_win_get_buf(win) ~= state.buffers.main then
		return default_picker_height()
	end
	if picker_main_heights[win] == nil then
		local items = pick.get_picker_items()
		if items == nil then
			return nil
		end
		local matches = pick.get_picker_matches() or {}
		local count = #(matches.all_inds or items)
		if count == 0 then
			return nil
		end
		picker_main_heights[win] = math.min(count, default_picker_height())
	end
	return picker_main_heights[win]
end

local function start_picker(source, opts, command)
	opts = vim.tbl_deep_extend("force", { source = source }, opts or {})
	local pick = require("mini.pick")
	if command then
		return pick.builtin.cli({ command = command }, opts)
	end
	return pick.start(opts)
end

local function jump_single_item(pick)
	local start = pick.start
	return function(opts)
		local source = opts and opts.source
		local items = source and source.items
		if
			not pick.is_picker_active()
			and type(items) == "table"
			and vim.islist(items)
			and #items == 1
			and type(items[1]) == "table"
		then
			local name = source.name
			if type(name) == "string" and (name:match("^LSP %(") or name:match("^Diagnostic %(")) then
				return pick.default_choose(items[1])
			end
		end
		return start(opts)
	end
end

local function todos_picker(opts)
	local Config = require("todo-comments.config")
	local Highlight = require("todo-comments.highlight")
	local ns = vim.api.nvim_create_namespace("todo_comments_picker")
	local pick = require("mini.pick")

	local function make_item(result)
		local path = result.filename
		local display_path = vim.fn.fnamemodify(path, ":.")
		local line = result.line:gsub("\t", string.rep(" ", vim.o.tabstop))
		local start, finish, raw_kw = Highlight.match(line)
		local kw = raw_kw and (Config.keywords[raw_kw] or raw_kw)
		local kw_opts = kw and Config.options.keywords[kw]
		if not (start and kw_opts) then
			return
		end

		local icon = vim.trim(kw_opts.icon or "")
		local icon_prefix = icon == "" and "" or (icon .. " ")
		local prefix = string.format("%s%s:%d:%d: ", icon_prefix, display_path, result.lnum, result.col)
		local text = prefix .. line

		local todo_start = 0
		local todo_end = todo_start + #icon
		local kw_start = #prefix + (start - 1)
		local kw_end = #prefix + (finish - 1)

		return {
			path = path,
			lnum = result.lnum,
			col = result.col,
			text = text,
			tag = kw,
			_todo_start = todo_start,
			_todo_end = todo_end,
			_todo_hl = "TodoFg" .. kw,
			_kw_start = kw_start,
			_kw_end = kw_end,
			_kw_hl = "TodoBg" .. kw,
		}
	end

	local function show(buf_id, items, query)
		require("mini.pick").default_show(buf_id, items, query)
		vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
		for i, item in ipairs(items) do
			local row = i - 1
			local function mark(from, to, hl)
				if from and to and from < to then
					pcall(vim.api.nvim_buf_set_extmark, buf_id, ns, row, from, {
						end_col = to,
						hl_group = hl,
					})
				end
			end
			mark(item._todo_start, item._todo_end, item._todo_hl)
			mark(item._kw_start, item._kw_end, item._kw_hl)
		end
	end

	local function preview(buf_id, item)
		require("mini.pick").default_preview(buf_id, item)
		if type(item) == "table" and item.path then
			local last = vim.api.nvim_buf_line_count(buf_id) - 1
			pcall(Highlight.highlight, buf_id, 0, last)
		end
	end

	local source = {
		name = "Todos",
		show = show,
		preview = preview,
		items = function()
			require("todo-comments.search").search(function(results)
				local items = {}
				for _, result in ipairs(results) do
					local item = make_item(result)
					if item then
						items[#items + 1] = item
					end
				end
				pick.set_picker_items(items)
			end, { disable_not_found_warnings = true })
		end,
	}
	return start_picker(source, opts)
end

local function git_log_line_picker(opts)
	local pick = require("mini.pick")
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Buffer is not a file", vim.log.levels.WARN)
		return
	end
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local repo = vim.fn.systemlist({ "git", "-C", vim.fn.fnamemodify(file, ":h"), "rev-parse", "--show-toplevel" })[1]
	if vim.v.shell_error ~= 0 then
		vim.notify("Not inside a Git repository", vim.log.levels.WARN)
		return
	end

	local function preview(buf_id, item)
		if type(item) ~= "string" then
			return pick.default_preview(buf_id, item)
		end
		local has_parser, parser = pcall(vim.treesitter.get_parser, buf_id, "git", { error = false })
		has_parser = has_parser and parser ~= nil
		if has_parser then
			has_parser = pcall(vim.treesitter.start, buf_id, "git")
		end
		if not has_parser then
			vim.bo[buf_id].syntax = "git"
		end
		local lines = vim.fn.systemlist({ "git", "-C", repo, "--no-pager", "show", item:match("^(%S+)") })
		vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
	end

	local function choose(item)
		local win = (pick.get_picker_state().windows or {}).target
		if win == nil or not vim.api.nvim_win_is_valid(win) then
			return
		end
		local buf_id = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_name(buf_id, "minipick://" .. buf_id .. "/" .. item:match("^(%S+)"))
		preview(buf_id, item)
		vim.bo[buf_id].filetype = "git"
		vim.api.nvim_win_set_buf(win, buf_id)
	end

	local command = {
		"git",
		"-C",
		repo,
		"--no-pager",
		"log",
		"--format=format:%h %s (%ch) <%an>",
		"--abbrev-commit",
		"--decorate",
		"--date=short",
		"--no-show-signature",
		"--no-patch",
		"-L",
		line .. ",+1:" .. file,
	}
	local source = { name = "Git log (line)", cwd = repo, preview = preview, choose = choose }
	return start_picker(source, opts, command)
end

return {
	{
		-- picker for everything
		"nvim-mini/mini.pick",
		dependencies = {
			{
				"nvim-mini/mini.extra",
				opts = {},
			},
		},
		opts = {
			mappings = {
				scroll_down = "<C-j>", -- instead of <C-f>
				scroll_up = "<C-k>", -- instead of <C-b>
			},
			options = {
				content_from_bottom = true,
			},
			window = {
				prompt_prefix = " ",
				config = function()
					local height = picker_height()
					if height == nil then
						return {}
					end
					return { height = height }
				end,
			},
		},
		lazy = false,
		config = function(_, opts)
			local pick = require("mini.pick")
			pick.setup(opts)
			pick.start = jump_single_item(pick)

			vim.api.nvim_create_autocmd("BufLeave", {
				callback = function(args)
					local state = pick.get_picker_state()
					if state == nil or vim.api.nvim_get_current_win() ~= state.windows.main then
						return
					end
					if args.buf == state.buffers.main then
						picker_main_heights[state.windows.main] = vim.api.nvim_win_get_height(state.windows.main)
					end
				end,
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					local state = pick.get_picker_state()
					if state ~= nil and vim.api.nvim_get_current_win() == state.windows.main then
						pick.refresh()
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniPickStop",
				callback = function()
					picker_main_heights = {}
				end,
			})

			local sized_win
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniPickMatch",
				callback = function()
					local pick = require("mini.pick")
					local state = pick.get_picker_state()
					if state == nil or state.windows.main == sized_win then
						return
					end
					sized_win = state.windows.main
					pick.refresh()
				end,
			})

			MiniPick.registry.todos = todos_picker
			MiniPick.registry.git_log_line = git_log_line_picker
			MiniPick.registry.diagnostics_buffer = function(local_opts)
				return require("mini.extra").pickers.diagnostic(
					vim.tbl_deep_extend("force", local_opts or {}, { scope = "current" })
				)
			end
		end,
		keys = {
			{
				"<leader>ff",
				"<cmd>Pick files<cr>",
				desc = "Pick files",
			},
			{
				"<leader>fg",
				"<cmd>Pick grep_live<cr>",
				desc = "Pick grep live",
			},
			{
				"<leader>fr",
				"<cmd>Pick resume<cr>",
				desc = "Resume last picker",
			},
			{
				"<leader>,",
				"<cmd>Pick buffers<cr>",
				desc = "Buffers",
			},
		},
	},
}
