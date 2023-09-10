local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
	return
end

local servers = {
  "clangd",
	"lua_ls",
	"pyright",
  "nil_ls",
  "elixirls",
}

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("my.lsp.handlers").on_attach,
		capabilities = require("my.lsp.handlers").capabilities,
	}

	local conf_ok, conf_opts = pcall(require, "my.lsp.servers." .. server)
	if conf_ok then
		opts = vim.tbl_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
