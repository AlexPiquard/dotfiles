require("vim._core.ui2").enable({})
require("options")
require("autocmds")
require("lazy-setup")

vim.schedule(function()
	require("mappings")
end)
