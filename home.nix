{ pkgs, ... }: {
  home.username = "prometheus"; # Change this!
  home.homeDirectory = "/home/prometheus"; # Change this!
  home.stateVersion = "25.11"; 

  # Packages you want for your user (not system-wide)
  home.packages = with pkgs; [
    fastfetch
    obsidian
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  programs.alacritty.enable = true;
  programs.kitty.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

# The "Magic" code to auto-start Tmux
    # initContent = ''
    #   if [[ -z "$TMUX" ]] && [ "$TERM_PROGRAM" != "vscode" ]; then
    #     exec tmux attach-session -t default || tmux new-session -s default
    #   fi
    #   set -o vi
    # '';

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
    # extraConfig = ''
    #   set -g default-shell ${pkgs.zsh}/bin/zsh
    # '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. Provide dependencies (LSPs, Linters, Formatters)
    # This keeps them out of your global system path
    extraPackages = with pkgs; [
      lua-language-server
      nil # Nix LSP
      ripgrep
      fd
    ];

    # 2. Manage Plugins via Nix
    # Search for names at: https://search.nixos.org/flakes?type=packages&query=vimPlugins
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      (nvim-treesitter.withPlugins (p: [ p.lua p.nix p.vim p.markdown ]))
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
