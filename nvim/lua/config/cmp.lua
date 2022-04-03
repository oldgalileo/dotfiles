local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local types = require('cmp.types')

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-space>'] = cmp.mapping.complete(),
		['<C-c>'] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "vsnip" }
	}
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- cmp.setup({
--   sorting = {
--     priority_weight = 2,
--     comparators = {
--       cmp.config.compare.offset,
--       cmp.config.compare.exact,
--       cmp.config.compare.score,
--       function(entry1, entry2)
--           local kind1 = entry1:get_kind()
--           kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
--           local kind2 = entry2:get_kind()
--           kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
--           if kind1 ~= kind2 then
--               if kind1 == types.lsp.CompletionItemKind.Snippet then
--                   return false
--               end
--               if kind2 == types.lsp.CompletionItemKind.Snippet then
--                   return true
--               end
--               local diff = kind1 - kind2
--               if diff < 0 then
--                   return true
--               elseif diff > 0 then
--                   return false
--               end
--           end
--       end,
--       cmp.config.compare.sort_text,
--       cmp.config.compare.length,
--       cmp.config.compare.order,
--       cmp.config.compare.score,
--     },
--   },
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     -- Add tab support
--     ["<Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--     ["<S-Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm({
--       behavior = cmp.ConfirmBehavior.Insert,
--       select = true,
--     })
--   },
--   completion = {
--     completeopt = "menu,menuone,noinsert",
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'vsnip' },
--   },
--   window = {
--     completion = { -- rounded border; thin-style scrollbar
--       border = 'rounded',
--       scrollbar = '║',
--     },
--     documentation = { -- no border; native-style scrollbar
--       border = 'rounded',
--       scrollbar = '',
--       -- other options
--     },
--   },
-- })
