{
  pkgs,
  lib,
}: let
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    customRC = ''
      lua << EOF
        -- Remove per user configuration
        vim.opt.rtp:remove(table.concat({vim.call("stdpath", "data"), "site"}, "/"))
        vim.opt.rtp:remove(table.concat({vim.call("stdpath", "data"), "site", "after"}, "/"))
        vim.opt.rtp:remove(vim.call("stdpath", "config"))
        vim.opt.rtp:remove(table.concat({vim.call("stdpath", "config"), "after"}, "/"))

        -- Add in our user configuration
        vim.opt.rtp:prepend("${./config}")
        vim.opt.rtp:append(table.concat({"${./config}", "after"}, "/"))

        vim.opt.packpath = vim.opt.rtp:get()
      EOF
      luafile ${./config}/init.lua
    '';
    plugins = with pkgs.vimPlugins; lib.lists.forEach [
      # Syntax
      vim-pandoc-syntax
      nvim-treesitter.withAllGrammars
      # Themes
      catppuccin-nvim

      # UI
      indent-blankline-nvim
      gitsigns-nvim
      lualine-nvim
      neoscroll-nvim

      # LSP
      nvim-lspconfig
      fidget-nvim
      null-ls-nvim

      # Autocomplete
      nvim-cmp
      cmp-nvim-lua
      cmp-nvim-lsp
    ] (pkg: { plugin = pkg; });

    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
  };

  extraPackages = with pkgs; [
    # Generic
    codespell
    # Elixir
    elixir
    # Lua
    stylua
    # Nix
    alejandra
    deadnix
    statix
    # Python
    black

    # LSP servers
    clang-tools
    elixir_ls
    nil
    nodePackages.pyright
    lua-language-server
  ];
  extraWrapperArgs = ''--suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';

  neovim-drv = (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig // {
    wrapperArgs = pkgs.lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
  })).overrideAttrs (prev: {
    passthru = prev.passthru // {
      tests = pkgs.callPackage ./tests.nix { inherit neovim-drv; };
    };
  });
in neovim-drv
