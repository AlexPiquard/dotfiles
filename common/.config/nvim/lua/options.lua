local opt = vim.opt
local o = vim.o
local g = vim.g

-- Enable true color support in terminal
o.termguicolors = true

-- Use global statusline (single statusline for all windows)
o.laststatus = 3
-- Hide mode indicator (shown by statusline instead)
o.showmode = false

-- Use system clipboard for yank/paste
o.clipboard = "unnamedplus"
if vim.env.TMUX then
    g.clipboard = "tmux"
else
    g.clipboard = "osc52"
end
-- Highlight current line
o.cursorline = true
-- Only show line number on current line when cursorline is on
o.cursorlineopt = "number"
-- Disable line wrapping (horizontal scroll instead)
o.wrap = false
-- Disable reports (lines yanked, etc)
vim.opt.report = 999999

-- Case-insensitive search unless pattern contains uppercase
o.ignorecase = true
o.smartcase = true
-- Enable mouse support in all modes
o.mouse = "a"

-- Show numbers
o.number = true
-- Relative line numbers
o.relativenumber = true
-- Width of line number column
o.numberwidth = 2
-- Hide ruler in statusline
o.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

-- Always show sign column (prevents layout shift)
o.signcolumn = "yes"
-- Open new splits below current window
o.splitbelow = true
-- Open new splits to the right of current window
o.splitright = true
-- Time in ms to wait for key code sequence (e.g., for leader key)
o.timeoutlen = 400
-- Enable undo files (persist undo history across sessions)
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- show a border for native floating windows
o.winborder = "single"

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- disable some default providers (neovim tries to use these by default)
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- folds, none by default
opt.foldmethod = "expr"
opt.foldlevelstart = 99
-- no fold in diff mode
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.v.option_new then
      vim.o.foldenable = false
    end
  end,
})

-- overridden by guess-indent.nvim
-- vim.cmd('set noexpandtab tabstop=2 shiftwidth=0 softtabstop=0 smarttab')

-- which elements are saved across sessions
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

o.switchbuf = "usetab,useopen"
