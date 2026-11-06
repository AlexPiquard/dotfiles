require("vim._core.ui2").enable({})
require("options")
require("autocmds")
require("trust")
require("lazy-setup")

vim.schedule(function()
	require("mappings")
end)
