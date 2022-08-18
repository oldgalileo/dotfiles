set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
vim.o.mouse = 'a'
vim.o.number = true

vim.cmd('let g:cursorhold_updatetime = 100')
-- require('timer').add(
--   function()
--     if vim.fn.mode() == "n" then
--       vim.lsp.buf.hover()
--     end
--     return 1250
--   end
-- )

local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_better,
        ["<C-k>"] = actions.move_selection_worse,
        ["<C-q>"] = actions.send_to_qflist,
        ["<Esc>"] = actions.close,
      },
    },
  },
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local opts = {
  tools = {
    inlay_hints = {
      highlight = 'Comment',
    },
    hover_actions = {
      -- the border that is used for the hover window
      -- see vim.api.nvim_open_win()
      border = {
        {"╭", "FloatBorder"}, {"─", "FloatBorder"},
        {"╮", "FloatBorder"}, {"│", "FloatBorder"},
        {"╯", "FloatBorder"}, {"─", "FloatBorder"},
        {"╰", "FloatBorder"}, {"│", "FloatBorder"}
      },

      -- whether the hover action window gets automatically focused
      auto_focus = false
    },
  },
  server = {
    settings = {
      ['rust-analyzer'] {
        procMacro {
          enable = true
        }
      }
    }
  }
}
require('rust-tools').setup(opts)

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
local types = require('cmp.types')
cmp.setup({
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      function(entry1, entry2)
          local kind1 = entry1:get_kind()
          kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
          local kind2 = entry2:get_kind()
          kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
          if kind1 ~= kind2 then
              if kind1 == types.lsp.CompletionItemKind.Snippet then
                  return false
              end
              if kind2 == types.lsp.CompletionItemKind.Snippet then
                  return true
              end
              local diff = kind1 - kind2
              if diff < 0 then
                  return true
              elseif diff > 0 then
                  return false
              end
          end
      end,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
      cmp.config.compare.score,
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },
  window = {
    completion = { -- rounded border; thin-style scrollbar
      border = 'rounded',
      scrollbar = '║',
    },
    documentation = { -- no border; native-style scrollbar
      border = 'rounded',
      scrollbar = '',
      -- other options
    },
  },
})
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- Diagonstics
require("trouble").setup({
  icons = false,
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local signature_config = {
  log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
  debug = true,
  hint_enable = false,
  handler_opts = { border = "rounded" },
  max_width = 80,
  bind = true,
}
require('lsp_signature').setup(signature_config)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

vim.o.background = 'dark'
local colors = require('ayu.colors')
colors.generate()

require('ayu').setup({
  overrides = {
    IncSearch = { fg = colors.fg }
  }
})

require('ayu').colorscheme()
EOF
