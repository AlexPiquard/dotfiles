require("options")
require("config.lazy")
require("vim._core.ui2").enable({})

vim.schedule(function()
	require("mappings")
end)
