local hostname = string.lower(vim.fn.hostname())

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          cmd = { "nixd" },
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
                  expr = string.format(
                    '(builtins.getFlake "/home/giu/.dotfiles").nixosConfigurations.%s.options',
                    hostname
                  ),
                },
                home_manager = {
                  expr = string.format(
                    '(builtins.getFlake "/home/giu/.dotfiles").homeConfigurations.%s.options',
                    hostname
                  ),
                },
              },
            },
          },
        },
      },
    },
  },
}
