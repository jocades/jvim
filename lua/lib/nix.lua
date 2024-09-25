vim.system({ "nix", "--help" }, {}, function(p)
  JVim.ins(p.stdout)
end)

-- JVim.float_term({ "nix", "serch", "nixpkgs", "cargo", "--json", "|", "jq" })
