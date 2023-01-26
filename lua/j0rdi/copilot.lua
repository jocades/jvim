-- Use this table to disable/enable filetypes
--vim.g.copilot_filetypes = { xml = false }

-- Since most are enabled by default you can turn them off
-- Using this table and only enable for a few filetypes
-- vim.g.copilot_filetypes = { ["*"] = false, python = true }

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

vim.keymap.set('i', '<C-i>', 'copilot#Accept("<CR>")', { expr = true, silent = true })

-- <C-]>                   Dismiss the current suggestion.
-- <Plug>(copilot-dismiss)
--
--                                                 *copilot-i_ALT-]*
-- <M-]>                   Cycle to the next suggestion, if one is available.
-- <Plug>(copilot-next)
--
--                                                 *copilot-i_ALT-[*
-- <M-[>                   Cycle to the previous suggestion.
-- <Plug>(copilot-previous)

-- vim.cmd [[highlight CopilotSuggestion guifg=#555555 ctermfg=8]]
