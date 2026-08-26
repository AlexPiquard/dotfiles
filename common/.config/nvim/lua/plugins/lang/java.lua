local function mise_java_bin(version)
	if vim.fn.executable("mise") == 1 then
		local handle = io.popen("mise where java@" .. version .. " 2>/dev/null")
		if handle then
			local path = handle:read("*a"):gsub("%s+", "")
			handle:close()
			if path ~= "" then
				return path .. "/bin/java"
			end
		end
	end
	return nil
end

return {
	{
		"mfussenegger/nvim-jdtls",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "java",
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = function(_, _)
			local jdk_latest = mise_java_bin("latest") or vim.fn.executable("java") == 1 and "java" or nil
			local jdk_17 = mise_java_bin("17")

			if not jdk_latest then
				vim.notify("jdtls: no Java found via mise or PATH", vim.log.levels.WARN)
				return {}
			end

			local jdtlsCmd = { "jdtls", "--java-executable", jdk_latest }

			local bundles = {
				vim.fn.glob(
					vim.fn.stdpath("data") .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"
				),
			}

			local config = {
				servers = {
					jdtls = {
						cmd = jdtlsCmd,
						settings = {},
						init_options = {
							bundles = bundles,
						},
						on_attach = function()
							require("jdtls").setup_dap({ hotcodereplace = "auto" })
						end,
					},
				},
			}

			if jdk_17 then
				config.servers.jdtls.settings = {
					java = {
						configuration = {
							runtimes = {
								{ name = "JavaSE-17", path = jdk_17 },
							},
						},
					},
				}
			end

			return config
		end,
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				jdtls = true,
				["java-debug-adapter"] = true,
			},
		},
	},
}
