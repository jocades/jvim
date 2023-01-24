local present, git_signs = pcall(require, "gitsigns")

if not present then
  return
end

-- See `:help gitsigns.txt`
git_signs.setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
}
