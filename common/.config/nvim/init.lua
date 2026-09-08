require("vim._core.ui2").enable({})
require("options")
require("autocmds")
require("config.lazy")

vim.schedule(function()
	require("mappings")
end)
