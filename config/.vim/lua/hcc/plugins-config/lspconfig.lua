local nvim_lsp = require("lspconfig")

-- -vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
-- -vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

function common_on_attach(client, bufnr)
	-- Customize diagnostics
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		signs = true,
		underline = true,
		update_in_insert = false,
	})

	-- Keymaps
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }

	function bufmap(lhs, rhs)
		vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, opts)
	end
	function vbufmap(lhs, rhs)
		vim.api.nvim_buf_set_keymap(bufnr, "v", lhs, rhs, opts)
	end

	-- - bufmap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
	-- - bufmap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
	-- - bufmap("gR", "<cmd>lua vim.lsp.buf.rename()<CR>")
	-- - bufmap("gr", "<cmd>Telescope lsp_references<CR>")
	-- - bufmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	-- - bufmap("K", '<Cmd>lua vim.lsp.buf.hover({ border = "single" })<CR>')
	-- - bufmap("<leader>sig", "<cmd>lua vim.lsp.buf.signature_help()<CR>")  -- Default "C-k" conflicts with my switch windows mapping

	-- - bufmap("ge", '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>')
	-- - bufmap("[e", '<cmd>lua vim.diagnostic.goto_prev({ border = "single" })<CR>')
	-- - bufmap("]e", '<cmd>lua vim.diagnostic.goto_next({ border = "single" })<CR>')

	-- - bufmap("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	-- - bufmap("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	-- - bufmap("<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

	-- - bufmap("<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
	-- - bufmap("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	-- - bufmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	-- - vbufmap("<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>")

	bufmap("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
	bufmap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
	bufmap("gdd", "<Cmd>Lspsaga preview_definition<CR>")
	bufmap("gR", "<cmd>Lspsaga rename<CR>")
	bufmap("gr", "<cmd>Telescope lsp_references<CR>")
	bufmap("grr", "<cmd>Lspsaga lsp_finder<CR>")
	bufmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	bufmap("K", '<Cmd>Lspsaga hover_doc<CR>')
	bufmap("gs", "<cmd>Lspsaga signature_help<CR>")  -- Default "C-k" conflicts with my switch windows mapping

	bufmap("ge", '<cmd>Lspsaga show_line_diagnostics<CR>')
	bufmap("[e", '<cmd>Lspsaga diagnostic_jump_prev<CR>')
	bufmap("]e", '<cmd>Lspsaga diagnostic_jump_next<CR>')

	bufmap("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	bufmap("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	bufmap("<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

	bufmap("<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
	bufmap("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	bufmap("<leader>ca", "<cmd>Lspsaga code_action<CR>")
	vbufmap("<leader>ca", "<cmd>Lspsaga range_code_action<CR>")
        -- NO! I don't like format-on-save:
	-- if client.resolved_capabilities.document_formatting then
	-- 	vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	-- end
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
--TODO: Can't get this to work. Why is cmp_nvim_lsp not found even though it
--clearly exists!?  Ugh!
--capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Column Sign for Diagnostics
-- Neovim 0.6+
-- -local signs = {
-- -	{ name = "DiagnosticSignError", text = "" },
-- -	{ name = "DiagnosticSignWarn", text = "" },
-- -	{ name = "DiagnosticSignHint", text = "" },
-- -	{ name = "DiagnosticSignInfo", text = "" },
-- -}
-- -
-- -for _, sign in ipairs(signs) do
-- -	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
-- -end

-- Enable the following language servers
local servers = {
  "bashls",  -- TODO: Make zsh filetype use this
  "clangd",
  "cssls",
  "dockerls",
  "dotls",
  --"rust_analyzer",
  "html",
  "jsonls",
  "pyright",
  "yamlls",  -- TODO: Add some schema support, .sls ft, etc
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    on_attach = common_on_attach,
    capabilities = capabilities,
  })
end

-- -require("lsp/tsserver")
-- -require("lsp/null-ls")
-- -require("lsp/gopls")
