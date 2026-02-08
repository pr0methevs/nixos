{ pkgs, ... }: {
  home.username = "prometheus"; # Change this!
  home.homeDirectory = "/home/prometheus"; # Change this!
  home.stateVersion = "25.11"; 

  # Packages you want for your user (not system-wide)
  home.packages = with pkgs; [
    fastfetch
    obsidian
    tmux
    brave
    quickshell
    libreoffice
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  programs.alacritty.enable = true;

  programs.kitty = {
      enable = true;
      extraConfig = ''
          background #161616
           # alternate, darker background #111111
          foreground #adacac
          selection_background #333333
          selection_foreground #adacac
          # url_color bluu
          cursor #adacac
          cursor_text_color #161616

          # Tabs
          active_tab_background #333333
          active_tab_foreground #a7ab93
          inactive_tab_background #1b1c1d
          # inactive_tab_foreground grey
          #tab_bar_background #161616

          # Windows
          active_border_color #a7ab93
          inactive_border_color #696969

          # normal
          color0 #696969
          color1 #9e5560
          color2 #5C635F
          color3 #b0b58a
          color4 #565A63
          color5 #5C5A66
          color6 #695C55
          color7 #717070

          # bright
          color8 #696969
          color9 #9c797d
          color10 #8a968f
          color11 #b5ae84
          color12 #808796
          color13 #8a879c
          color14 #a18b7f
          color15 #adacac

          # extended colors
          color16 #111111
          color17 #a7ab93

      '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

# The "Magic" code to auto-start Tmux
    initContent = ''
    #   if [[ -z "$TMUX" ]] && [ "$TERM_PROGRAM" != "vscode" ]; then
    #     exec tmux attach-session -t default || tmux new-session -s default
    #   fi
    '';

    shellAliases = {
      ll = "eza -l";
      la = "eza -la";
      update = "sudo nixos-rebuild switch --flake .#nixos";
      svim = "sudo -E nvim";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true; # Let's be honest, mouse support is nice
    extraConfig = ''
      set -g default-shell ${pkgs.zsh}/bin/zsh
      set -g mode-keys vi
      set -g status-keys vi
      set-option -sg escape-time 10
      set-option -g focus-events on
      # set-option -g default-terminal "screen-256color:RGB"
      set -g base-index 1
      set -g renumber-windows on
      bind r source-file "~/.config/tmux/tmux.conf"
    '';
  };

  # programs.go = {
  #   enable = true;
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. Provide dependencies (LSPs, Linters, Formatters)
# This keeps them out of your global system path
    extraPackages = with pkgs; [
        actionlint # GH Actions
        angular-language-server
        bash-language-server
        # docker-language-server
        dockerfile-language-server
        fd
        gopls
        java-language-server
        jdt-language-server
        jq-lsp
        kotlin-language-server
        lua-language-server
        nil # Nix LSP
        nixd
        pyright
        ripgrep
        rust-analyzer
        terraform-ls
        typescript-language-server
        vscode-json-languageserver
        yaml-language-server
        nodePackages.vscode-langservers-extracted # Provides HTML, CSS, JSON, and ESLint LSPs!
    ];

    # 2. Manage Plugins via Nix
    # Search for names at: https://search.nixos.org/flakes?type=packages&query=vimPlugins
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp    # Suggestions from the Language Server
      cmp-buffer      # Suggestions from the current file text
      cmp-path        # Suggestions for file system paths
      cmp-cmdline     # Suggestions for the command line (:)
    
      # --- Snippets (Highly Recommended) ---
      # nvim-cmp usually needs a snippet engine to work well
      luasnip         # The snippet engine
      cmp_luasnip     # Link between nvim-cmp and luasnip
      neo-tree-nvim
      (nvim-treesitter.withPlugins (p: [ 
          p.angular 
          p.bash 
          p.css 
          p.jq 
          p.json 
          p.lua 
          p.markdown 
          p.nix 
          p.python 
          p.toml 
          p.typescript 
          p.vim 
          ])
      )
      telescope-nvim
      gruvbox-nvim
    ];
  };

  # 3. The Purist Symlink
  # This maps ./nvim to ~/.config/nvim
  xdg.configFile."nvim" = {
    source = ./nvim; # Path relative to this nix file
    recursive = true;
  };

  programs.keepassxc = {
    enable = true;
    settings = {
      # This tells KeePassXC to act as the Secret Service provider
      FdoSecrets = {
        Enabled = true;
      };
      # Optional: integrate with your browser
      Browser = {
        Enabled = true;
      };
    };
  };

  # Use systemd to ensure it starts as a background daemon on login
  systemd.user.services.keepassxc = {
    Unit = {
      Description = "KeePassXC password manager";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
