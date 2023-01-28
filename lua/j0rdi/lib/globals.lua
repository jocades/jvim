function Flex()
  local friend_name = vim.fn.input 'Who are we flexing on?: '
  friend_name = friend_name:gsub('^%l', string.upper)
  local msg = string.format(" %s... Jordi's config is on another level! He wrote it in Lua! ", friend_name)
  vim.notify(msg, vim.log.levels.WARN, { title = 'Flex' })
end
