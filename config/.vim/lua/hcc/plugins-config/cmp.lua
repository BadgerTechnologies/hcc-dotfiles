local cmp = require('cmp')
local types = require('cmp.types')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }), -- Start manual completion
    ['<C-y>'] = cmp.config.disable, -- Removes the default `<C-y>` mapping (which is 'confirm')
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Down>'] = cmp.mapping({i = cmp.mapping.select_next_item()}),
    ['<Up>'] = cmp.mapping({i = cmp.mapping.select_prev_item()}),
    -- - ['<Tab>'] = function(fallback)
    -- -   cmp.select_next_item()
    -- - end,
    --['<Tab>'] = cmp.mapping(
    --  function(fallback)
    --    if cmp.visible() then
    --      if cmp.core.view:get_selected_entry() then
    --        cmp.core.view:_select(1, cmp.SelectBehavior.Insert)
    --        -- cmp.select_next_item()
    --      else
    --        cmp.core.view:_select(1, cmp.SelectBehavior.Insert)
    --      end
    --    elseif luasnip.expand_or_jumpable() then
    --      luasnip.expand_or_jump()
    --    elseif has_words_before() then
    --      cmp.complete()
    --    else
    --      fallback()
    --    end
    --  end,
    --  { 'i', 's' }
    --),
    ['<Tab>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          --I don't really like cycling through with <Tab>. Just accept current (or first) entry
          --cmp.select_next_item()
          cmp.confirm({select = false})
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      { 'i', 's' }
    ),
    ['<S-Tab>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      { 'i', 's' }
    ),
  },
  sources = {
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'buffer', keyword_length = 3 },
  },
  completion = { completeopt = 'menu,menuone,noinsert' },
  formatting = {
    format = lspkind.cmp_format({
      -- with_text = false,
      -- maxwidth = 50,
      -- before = function(entry, vim_item) return vim_item enabled
    })
  },
})

-- - -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- - cmp.setup.cmdline('/', {
-- -   sources = {
-- -     { name = 'buffer' }
-- -   }
-- - })
-- - 
-- - -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- - cmp.setup.cmdline(':', {
-- -   sources = cmp.config.sources({
-- -     { name = 'path' }
-- -   }, {
-- -     { name = 'cmdline' }
-- -   })
-- - })
-- - 
-- - -- Setup lspconfig.
-- - local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- - -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- - require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
-- -   capabilities = capabilities
-- - }
