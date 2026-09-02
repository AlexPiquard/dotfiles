-- change diagnostics config like icons in left column of editor
local x = vim.diagnostic.severity
vim.diagnostic.config({
	virtual_text = { prefix = "" },
	signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
	underline = true,
	float = { border = "single" },
})

-- what client can do, sent to lsp server
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

vim.lsp.config("*", {
	capabilities = capabilities,
})

-- show lsp progress with "progress messages" (nvim_echo)
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value
		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. ev.data.client_id,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

-- register mappings when lsp server is attached
local map = vim.keymap.set
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local function opts(desc)
			return { buffer = args.buf, desc = "LSP " .. desc }
		end

		-- "go to references" is mapped in snacks.picker
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))

		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts("List workspace folders"))

		map("n", "<leader>T", vim.lsp.buf.type_definition, opts("Go to type definition"))

		-- enable inlay hints if supported
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})

-- nvim-lspconfig is a list of configs to use lsp servers
-- mason is used to install lsp servers
return {
	{
		"mason-org/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = {
			-- PATH = "skip",

			ui = {
				icons = {
					package_pending = " ",
					package_installed = " ",
					package_uninstalled = " ",
				},
			},

			max_concurrent_installers = 10,

			ensure_installed = {
				stylua = true,
				["lua-language-server"] = true,
			},
		},
		---@param opts MasonSettings | {ensure_installed: table<string, boolean|{executable_cond: string}>}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			mr.refresh(function()
				for pkg, config in pairs(opts.ensure_installed) do
					if
						config
						and (
							type(config) ~= "table"
							or (config.executable_cond and vim.fn.executable(config.executable_cond) == 1)
						)
					then
						local p = mr.get_package(pkg)
						if not p:is_installed() then
							p:install()
						end
					end
				end
			end)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			servers = {
				stylua = true,
				lua_ls = true,
			},
		},
		config = function(_, opts)
			for server, config in pairs(opts.servers) do
				if config then
					if config == true then
						config = {}
					end
					vim.lsp.config(server, config)
					vim.lsp.enable(server)
				end
			end
		end,
	},
}
