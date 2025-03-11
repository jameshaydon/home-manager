{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "james";
  home.homeDirectory = "/Users/james";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.just
    pkgs.gitAndTools.delta
    # pkgs.z3
    pkgs.nodejs
    # pkgs.nodePackages.pnpm
    pkgs.ripgrep
    pkgs.yt-dlp
    pkgs.jq
    pkgs.sqlite
    pkgs.nodePackages.serve
    pkgs.gh
    pkgs.tree

    pkgs.idris2

    pkgs.ffmpeg

    # Spellchecking stuff:
    pkgs.enchant # We use the enchant spell-checking library.
    pkgs.hunspell # The enchant library uses the hunspell backend.
    pkgs.hunspellDicts.en_US
    pkgs.hunspellDicts.fr-moderne
    # (pkgs.aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jameshaydon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    bash.enable = true;
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      shellAliases = {
        hm = "run home-manager";
        # ls = "exa";
        cf = "cabal --ghc-options=\"-j4 +RTS -A128m -n2m -qg -RTS\" --disable-optimization --disable-library-vanilla --enable-executable-dynamic";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins=["git" "macos" "brew" "fzf" "direnv"];
      };
      initExtra =
        ''
        # Locale.
        LC_CTYPE=en_US.UTF-8
        LC_ALL=en_US.UTF-8

        # NOTE: the 'run' scipt in _this_ repo:
        export PATH="$PATH:$HOME/nix-home/bin"

        # NOTE: this is used by vterm in emacs:
        vterm_printf(){
            if [ -n "$TMUX" ]; then
                # Tell tmux to pass the escape sequences through
                # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
                printf "\ePtmux;\e\e]%s\007\e\\" "$1"
            elif [ "''${TERM%%-*}" = "screen" ]; then
                # GNU screen (screen, screen-256color, screen-256color-bce)
                printf "\eP\e]%s\007\e\\" "$1"
            else
                printf "\e]%s\e\\" "$1"
            fi
        }

        # NOTE: Doom scripts:
        export PATH="$PATH:$HOME/.emacs.d/bin"

        # NOTE: where haskell installs stuff:
        export PATH="$PATH:$HOME/.local/bin"

        # NOTE: locally installed npm modules
        export PATH="$PATH:./node_modules/.bin"

        # NOTE: where brew cask installs latex
        export PATH="$PATH:/Library/TeX/texbin"

        # NOTE: ghcup:
        export PATH="$PATH:$HOME/.ghcup/bin"
        [ -f "/Users/james/.ghcup/env" ] && . "/Users/james/.ghcup/env" # ghcup-env

        # NOTE: cabal executables:
        export PATH="$PATH:$HOME/.cabal/bin"

        # NOTE: python pip stuff:
        export PATH="$PATH:$HOME/Library/Python/3.9/bin"

        # Anthropic
        if [ -f "$HOME/.anthropic-api-key" ]; then
          export ANTHROPIC_API_KEY=$(cat $HOME/.anthropic-api-key)
        fi

        # OpenAI
        if [ -f "$HOME/.openai-api-key" ]; then
          export OPENAI_API_KEY=$(cat $HOME/.openai-api-key)
        fi

        # OpenRouter
        if [ -f "$HOME/.openrouter-api-key" ]; then
          export OPENROUTER_API_KEY=$(cat $HOME/.openrouter-api-key)
        fi
        '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "James Henri Haydon";
      userEmail = "james.haydon@gmail.com";
      ignores = [
        ".DS_Store"
        "**/.DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "*.niu"
        ".local"
      ];
      aliases = {};
      extraConfig = {
        color.diff-highlight.oldNormal = "red bold";
        color.diff-highlight.oldHighlight = "red bold 52";
        color.diff-highlight.newNormal = "green bold";
        color.diff-highlight.newHighlight = "green bold 22";
        color.diff.meta = "11";
        color.diff.frag = "magenta bold";
        color.diff.func = "146 bold";
        color.diff.commit = "yellow bold";
        color.diff.old = "red bold";
        color.diff.new = "green bold";
        color.diff.whitespace = "red reverse";
        color.ui = "true";
        color.branch = "auto";
        color.status = "auto";
        color.interactive = "auto";
        log.decorate = "full";
        diff.algorithm = "minimal";
        diff.mnemonicprefix = "true";
        merge.statue = "true";
        merge.summary = "true";
        merge.conflictStyle = "diff3";
        github.user = "jameshaydon";
        rerere.enabled = "true";
        rerere.autoupdate = "true";
        credential.helper = "cache --timeout=604800";
        branch.autosetuprebase = "always";
        push.recurseSubmodules = "no";
        rebase.autosquash = "true";
        submodule.recurse = "true";
        delta.features = "side-by-side line-numbers";
        delta.whitespace-error-style = "22 reverse";
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
      };
    };
  };
}
