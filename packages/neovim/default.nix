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
        vim.opt.rtp:remove(vim.call("stdpath", "config")) vim.opt.rtp:remove(table.concat({vim.call("stdpath", "config"), "after"}, "/"))

        -- Add in our user configuration
        vim.opt.rtp:prepend("${./config}")
        vim.opt.rtp:append(table.concat({"${./config}", "after"}, "/"))

        vim.opt.packpath = vim.opt.rtp:get()
      EOF
      luafile ${./config}/init.lua
    '';
    plugins = with pkgs.vimPlugins;
      lib.lists.forEach [
        # Syntax
        (pkgs.vimUtils.buildVimPlugin {
          pname = "vim-crystal";
          version = "2023-05-21";
          src = pkgs.fetchFromGitHub {
            owner = "jlcrochet";
            repo = "vim-crystal";
            rev = "fbaa42625303838a9be860250323364fe5658b0c";
            sha256 = "sha256-BSo/mDymFxBQjx6Gbcewji0Yv/Vs4QVw1BtcAG3FFOA=";
          };
          meta.homepage = "https://github.com/jlcrochet/vim-crystal/";
        })
        vim-pandoc-syntax
        nvim-treesitter.withAllGrammars
        # Themes
        catppuccin-nvim

        # UI
        indent-blankline-nvim
        git-conflict-nvim
        gitsigns-nvim
        lualine-nvim
        #neoscroll-nvim

        # LSP
        nvim-lspconfig
        fidget-nvim
        null-ls-nvim

        # Autocomplete
        nvim-cmp
        cmp-nvim-lua
        cmp-nvim-lsp
      ] (pkg: {plugin = pkg;});

    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
  };

  extraPackages = with pkgs; [
    # Generic
    codespell
    git
    # C/C++
    gcc
    # Nix
    deadnix
    statix
    # Python
    black

    # LSP servers
    clang-tools
    crystalline
    elixir_ls
    nil
    pyright
    ruby-lsp
    lua-language-server
    emmet-ls
  ];
  extraWrapperArgs = ''--suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';

  neovim-drv =
    (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig
      // {
        wrapperArgs = pkgs.lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
      }))
    .overrideAttrs (prev: {
      passthru =
        prev.passthru
        // {
          tests.smoke = pkgs.runCommand "neovim-drv-smoke-test" {} ''
            export HOME=$TMPDIR
            export LC_ALL=C.UTF-8
            ${neovim-drv}/bin/nvim --headless +checkhealth +write!$out +quitall! -e
            echo "--- CHECKHEALTH RESULTS ---"
            cat $out
            if grep -q ERROR $out; then
              echo "--- ERRORS FOUND ---"
              grep -A 5 ERROR $out
              exit 1
            fi
          '';
        };
    });
in
  neovim-drv
