return {
	{
		-- Supercharge the rust experience
		"mrcjkb/rustaceanvim",
		version = "^8",
		ft = "rust",
		opts = {
			tools = {
				float_win_config = {
					auto_focus = false,
				},
			},
			server = {
				on_attach = function(_, _)
					-- vim.keymap.set("n", "<C-w>e", function()
					-- 	vim.cmd.RustLsp("explainError")
					-- end, { silent = true, desc = "Explain rust diagnostics", buffer = bufnr })
					-- vim.keymap.set("n", "<C-w>z", function()
					-- 	vim.cmd.RustLsp("renderDiagnostic")
					-- end, { silent = true, desc = "Render rust diagnotics", buffer = bufnr })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					-- install it with "rustup component add rust-analyzer"

					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = {
								enable = true,
							},
						},
						-- use bacon
						checkOnSave = false,
						diagnostics = {
							-- use bacon
							enable = false,
						},
						procMacro = {
							enable = true,
						},
						files = {
							exclude = {
								".direnv",
								".git",
								".jj",
								".github",
								".gitlab",
								"bin",
								"node_modules",
								"target",
								"venv",
								".venv",
							},
							-- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
							watcher = "client",
						},
					},
				},
			},
		},
		config = function(_, opts)
			local codelldb = vim.fn.exepath("codelldb")
			local codelldb_lib_ext = io.popen("uname"):read("*l") == "Linux" and ".so" or ".dylib"
			local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)

			-- use codelldb as debugger
			opts.dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
			}

			-- opts is used here
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})

			require("dap").configurations.rust = require("dap").configurations.rust or {}
			local meson_build_dir = nil
			table.insert(require("dap").configurations.rust, {
				type = "codelldb",
				request = "launch",
				name = "Meson GTK Rust",
				program = function()
					meson_build_dir = vim.fn.input("Build dir: ", "builddir")
					local name = vim.fn
						.system(
							"cargo metadata --no-deps --format-version=1 2>/dev/null | jq -r '.packages[0].name'"
						)
						:gsub("%s+", "")
					if name == "" then
						name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					end
					return vim.fn.getcwd() .. "/" .. meson_build_dir .. "/cargo-target/debug/" .. name
				end,
				cwd = "${workspaceFolder}",
				env = function()
					local output = vim.fn.system("meson devenv -C " .. vim.fn.getcwd() .. "/" .. meson_build_dir .. " env 2>/dev/null")
					local env = {}
					for line in output:gmatch("[^\r\n]+") do
						local k, v = line:match("^(%S+)=(.*)")
						if k then
							env[k] = v
						end
					end
					return env
				end,
			})
		end,
	},
	{
		-- curl -L https://raw.githubusercontent.com/cordx56/rustowl/refs/heads/main/scripts/installer | sh
		--
		-- 🟩 green: variable's lifetime
		--		- definitely live: the variable is provably initialized on every path reaching this point
		--		- maybe live (wavy): the variable is initialized on some paths but may have been moved, dropped, or be uninitialized on others
		-- 🟦 blue: immutable borrowing
		-- 🟪 purple: mutable borrowing
		-- 🟧 orange: value moved / function call
		-- 🟥 red: lifetime error
		--		- Diff of lifetime between actual and expected, or
		--		- Invalid overlapped lifetime of mutable and shared (immutable) references
		"cordx56/rustowl",
		cond = vim.fn.executable("rustowl") == 1,
		version = "*",
		ft = "rust",
		lazy = false,
		opts = {},
	},
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				bacon_ls = true,
				mesonlsp = true,
				blueprint_ls = true, -- sudo dnf install blueprint_compiler
			},
		},
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				bacon = {
					executable_cond = "cargo",
				},
				mesonlsp = true,
				codelldb = true,
			},
		},
	},
}
