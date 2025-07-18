local hostname = string.lower(vim.fn.hostname())
---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  single_file_support = true,
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "alejandra" },
      },
      options = {
        nixos = {
          expr = string.format('(builtins.getFlake "/home/giu/.dotfiles").nixosConfigurations.%s.options', hostname),
        },
        home_manager = {
          expr = string.format('(builtins.getFlake "/home/giu/.dotfiles").homeConfigurations.%s.options', hostname),
        },
      },
    },
  },
}
