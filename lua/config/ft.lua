vim.filetype.add({
  extension = {
    es = 'es',
  },
})

vim.filetype.add({
  extension = {
    mdx = 'markdown',
  },
})

vim.treesitter.language.register('markdown', 'mdx')

vim.filetype.add({
  extension = {
    astro = 'astro',
  },
})
