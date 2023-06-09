local lsp = require("lsp-zero")
local luasnip = require("luasnip")
lsp.preset("recommended")

-- lsp.ensure_installed({
--   'tsserver',
--   'rust_analyzer',
-- })

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item({cmp_select}),
  ['<C-n>'] = cmp.mapping.select_next_item({cmp_select}),
  ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
  }),
  ["<C-Space>"] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<S-Tab>'] = cmp.mapping(function (fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end
    ),
    ['<Tab>'] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end
    )

})

-- cmp_mappings['<Tab>'] = cmp.mapping(function(fallback)
--     if luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--     else
--         fallback()
--     end
-- end
-- )
-- cmp_mappings['<S-Tab>'] = cmp.mapping(function (fallback)
--     if luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--     else
--         fallback()
--     end
-- end
-- )
local cmp_config = lsp.defaults.cmp_config({
  window = {
    completion = cmp.config.window.bordered()
  }
})


cmp.setup(cmp_config)

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  preselect = 'none',
  completion = {
      completeopt = 'menu,menuone,noinsert,noselect'
  },
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

