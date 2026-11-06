local M = {}

local state_file = vim.fn.stdpath("state") .. "/trusted_projects.json"

local root_markers = {
	".git",
	".hg",
	".svn",
	"Cargo.toml",
	"go.mod",
	"package.json",
	"pyproject.toml",
	"composer.json",
	"Gemfile",
	"Makefile",
	"meson.build",
}

local servers = {}
local notified = {}

local function normalize(path)
	return vim.fs.normalize(path)
end

local function read_whitelist()
	local file = io.open(state_file, "r")
	if not file then
		return {}
	end

	local content = file:read("*a")
	file:close()

	local ok, list = pcall(vim.json.decode, content)
	if not ok or type(list) ~= "table" then
		return {}
	end

	local trusted = {}
	for _, path in ipairs(list) do
		if type(path) == "string" then
			trusted[normalize(path)] = true
		end
	end

	return trusted
end

local function write_whitelist(trusted)
	local list = vim.tbl_keys(trusted)
	table.sort(list)

	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")

	local file = io.open(state_file, "w")
	if not file then
		return
	end

	file:write(vim.json.encode(list))
	file:close()
end

function M.root(bufnr)
	bufnr = bufnr or 0

	local name = vim.api.nvim_buf_get_name(bufnr)
	local start = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()

	return normalize(vim.fs.root(start, root_markers) or start)
end

function M.is_trusted(root)
	root = normalize(root or M.root())
	return read_whitelist()[root] == true
end

function M.notify_untrusted(root)
	root = normalize(root or M.root())
	if notified[root] then
		return
	end

	notified[root] = true
	vim.notify(("LSP disabled: %s is not trusted. Run :Trust to enable it."):format(root), vim.log.levels.WARN)
end

function M.enable()
	for server, config in pairs(servers) do
		if config then
			vim.lsp.enable(server)
		end
	end
end

function M.disable()
	for server, config in pairs(servers) do
		if config then
			vim.lsp.enable(server, false)
		end
	end

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		client:stop()
	end
end

function M.setup_lsp(config)
	servers = config

	local root = M.root()
	if M.is_trusted(root) then
		M.enable()
	else
		M.notify_untrusted(root)
	end
end

function M.trust(root)
	root = normalize(root or M.root())

	local trusted = read_whitelist()
	trusted[root] = true
	write_whitelist(trusted)

	notified[root] = nil
	M.enable()

	return root
end

function M.untrust(root)
	root = normalize(root or M.root())

	local trusted = read_whitelist()
	trusted[root] = nil
	write_whitelist(trusted)

	notified[root] = nil
	M.disable()

	return root
end

local lsp_start = vim.lsp.start
vim.lsp.start = function(config, opts)
	local bufnr = opts and opts.bufnr or 0

	if not M.is_trusted(M.root(bufnr)) then
		M.notify_untrusted(M.root(bufnr))
		return
	end

	return lsp_start(config, opts)
end

local lsp_start_client = vim.lsp.start_client
if lsp_start_client then
	vim.lsp.start_client = function(config)
		if not M.is_trusted(M.root()) then
			M.notify_untrusted(M.root())
			return
		end

		return lsp_start_client(config)
	end
end

vim.api.nvim_create_user_command("Trust", function()
	local root = M.trust()
	vim.notify(("Trusted project: %s"):format(root), vim.log.levels.INFO)
end, { desc = "Trust current project and enable LSP" })

vim.api.nvim_create_user_command("Untrust", function()
	local root = M.untrust()
	vim.notify(("Removed trust for: %s"):format(root), vim.log.levels.INFO)
end, { desc = "Untrust current project and stop LSP" })

return M
