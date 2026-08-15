{ config, pkgs, agentSources, ... }:

let
  heyCli = (pkgs.buildGoModule.override { go = pkgs.go_1_26; }) {
    pname = "hey-cli";
    version = "unstable-2026-04-07";

    src = pkgs.fetchFromGitHub {
      owner = "basecamp";
      repo = "hey-cli";
      rev = "22aeea730eb28a70ccbc1701027d4883715914a9";
      hash = "sha256-QNBfHvD+mbMncOqPRR5fF6MIe41/LVMGO4THyFRpba8=";
    };

    vendorHash = "sha256-ZUFscklbaKw/sLIfDWfyjCRYKsdU9x3fWXER0zfCUpc=";

    subPackages = [ "cmd/hey" ];

    meta = {
      description = "CLI and TUI for HEY email";
      homepage = "https://github.com/basecamp/hey-cli";
      license = pkgs.lib.licenses.mit;
    };
  };

  worktreeLinkPrimary = pkgs.writeShellApplication {
    name = "wt-link-primary";
    runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.git ];
    text = ''
      if (( $# < 2 )); then
        echo "Usage: wt-link-primary PRIMARY_WORKTREE PATH..." >&2
        exit 2
      fi

      primary=$1
      shift

      if [[ ! -d "$primary" ]]; then
        echo "Primary worktree does not exist: $primary" >&2
        exit 1
      fi

      has_tracked_paths() {
        [[ -n "$(git ls-files -- "$1")" ]]
      }

      link_directory_entries() {
        local relative=$1
        local source=$primary/$relative
        local destination=$PWD/$relative

        while IFS= read -r -d "" entry; do
          local name
          local child_relative
          local child_destination
          name=$(basename "$entry")
          child_relative=$relative/$name
          child_destination=$PWD/$child_relative

          if has_tracked_paths "$child_relative"; then
            continue
          fi

          if [[ -e "$child_destination" || -L "$child_destination" ]]; then
            continue
          fi

          ln -s "$entry" "$child_destination"
          echo "Linked $child_relative"
        done < <(find "$source" -mindepth 1 -maxdepth 1 -print0)
      }

      for relative in "$@"; do
        case "$relative" in
          ""|/*|..|../*|*/../*|*/..)
            echo "Path must stay within the worktree: $relative" >&2
            exit 2
            ;;
        esac

        source=$primary/$relative
        destination=$PWD/$relative

        if [[ ! -e "$source" && ! -L "$source" ]]; then
          continue
        fi

        if has_tracked_paths "$relative"; then
          if [[ -d "$source" ]]; then
            mkdir -p "$destination"
            link_directory_entries "$relative"
          fi
          continue
        fi

        if [[ ! -e "$destination" && ! -L "$destination" ]]; then
          mkdir -p "$(dirname "$destination")"
          ln -s "$source" "$destination"
          echo "Linked $relative"
        elif [[ -d "$source" && -d "$destination" && ! -L "$destination" ]]; then
          link_directory_entries "$relative"
        fi
      done
    '';
  };

  wtStatusSkillDir = "${config.home.homeDirectory}/.agents/skills/wt-status";
  wtStatusConfig = "${config.xdg.configHome}/wt-status/config.json";

  wtStatusProject = path: checkName: argv: {
    inherit path;
    remote = "origin";
    sync_clean_worktrees = true;
    environment = {
      mode = "direnv";
      auto_allow = true;
      bootstrap = null;
    };
    checks = [{
      name = checkName;
      inherit argv;
      timeout_seconds = 900;
    }];
  };

  wtStatus = pkgs.writeShellApplication {
    name = "wt-status";
    runtimeInputs = [
      pkgs.python3
      pkgs.git
      pkgs.gh
      pkgs.worktrunk
      pkgs.direnv
      pkgs.nix
    ];
    text = ''
      exec python3 ${pkgs.lib.escapeShellArg "${wtStatusSkillDir}/scripts/wt_status.py"} \
        --config ${pkgs.lib.escapeShellArg wtStatusConfig} "$@"
    '';
  };

  buildNpmAgent = attrs:
    let
      package = builtins.fromJSON (builtins.readFile "${attrs.src}/package.json");
    in
    pkgs.buildNpmPackage (attrs // {
      inherit (package) version;
      npmDeps = pkgs.importNpmLock { npmRoot = attrs.src; };
      npmConfigHook = pkgs.importNpmLock.npmConfigHook;
    });

  claudeAgentAcp = buildNpmAgent {
    pname = "claude-agent-acp";
    src = agentSources.claude;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postInstall = ''
      wrapProgram $out/bin/claude-agent-acp \
        --set-default CLAUDE_CODE_EXECUTABLE ${pkgs.lib.getExe pkgs.claude-code}
    '';

    meta = {
      description = "ACP adapter for Claude Agent SDK";
      homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
      license = pkgs.lib.licenses.asl20;
      mainProgram = "claude-agent-acp";
    };
  };

  codexAcp = buildNpmAgent {
    pname = "codex-acp";
    src = agentSources.codex;

    meta = {
      description = "ACP adapter for Codex CLI";
      homepage = "https://github.com/agentclientprotocol/codex-acp";
      license = pkgs.lib.licenses.asl20;
      mainProgram = "codex-acp";
    };
  };

  piAcp = buildNpmAgent {
    pname = "pi-acp";
    src = agentSources.pi;

    meta = {
      description = "ACP adapter for Pi coding agent";
      homepage = "https://github.com/svkozak/pi-acp";
      license = pkgs.lib.licenses.mit;
      mainProgram = "pi-acp";
    };
  };
in
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
    heyCli
    worktreeLinkPrimary
    wtStatus
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
    pkgs.fd
    pkgs.delta
    # pkgs.z3
    pkgs.dafny
    pkgs.nodejs
    # pkgs.nodePackages.pnpm
    pkgs.git
    pkgs.ripgrep
    pkgs.pandoc
    # pkgs.yt-dlp
    pkgs.jq
    pkgs.sqlite
    pkgs.signal-cli
    pkgs.obsidian

    # A simple util to serve a dir as a website
    # pkgs.nodePackages.serve
    pkgs.gh
    pkgs.tree
    pkgs.worktrunk

    # pkgs.idris2
    pkgs.elan

    pkgs.ffmpeg

    # pkgs.aider-chat
    pkgs.claude-code
    pkgs.gemini-cli
    # pkgs.codex        
    pkgs.pi-coding-agent

    claudeAgentAcp
    codexAcp
    piAcp

    # Spellchecking stuff:
    # pkgs.enchant # We use the enchant spell-checking library.
    # pkgs.hunspell # The enchant library uses the hunspell backend.
    # pkgs.hunspellDicts.en_US
    # pkgs.hunspellDicts.fr-moderne
    (pkgs.aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

    pkgs.google-cloud-sdk
    pkgs.crane

    pkgs.emacs-lsp-booster

    pkgs.rclone

    pkgs.cachix

    pkgs.pkgs.iterm2

    pkgs.uv    
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "tuvok".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Library/CloudStorage/GoogleDrive-james.haydon@gmail.com/My Drive/tuvok";

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

  home.file.".aspell.conf".text = ''
    lang en_GB
  '';

  home.file.".codex/wt-status.config.toml".text = ''
    model_reasoning_effort = "low"
    approval_policy = "never"
    sandbox_mode = "read-only"
    web_search = "disabled"
  '';

  xdg.configFile."wt-status/config.json".text = builtins.toJSON {
    state_dir = "${config.xdg.stateHome}/wt-status";
    codex = {
      binary = "codex";
      profile = "wt-status";
      timeout_seconds = 600;
      daily_token_limit = null;
    };
    limits = {
      command_output_bytes = 65536;
      diff_bytes = 524288;
      prior_status_bytes = 65536;
      github_json_bytes = 16777216;
    };
    projects = [
      (wtStatusProject
        "${config.home.homeDirectory}/dev/imiron-io/specforge"
        "SpecForge API tests"
        [ "just" "api" "test-fast" ])
      (wtStatusProject
        "${config.home.homeDirectory}/dev/jameshaydon/weft"
        "Weft tests"
        [ "just" "test" ])
    ];
  };

  xdg.configFile."worktrunk/config.toml".text = ''
    [[pre-start]]
    transfer-direnv = "wt-link-primary {{ primary_worktree_path }} .envrc"

    [[pre-start]]
    allow-direnv = """
    if test ! -f .envrc; then
      exit 0
    fi

    primary={{ primary_worktree_path }}/.envrc

    if test -f "$primary" && cmp -s .envrc "$primary"; then
      direnv allow
    else
      printf '%s\\n' "Not auto-allowing .envrc: it differs from the primary worktree." >&2
    fi
    """
  '';

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
      profileExtra = ''
        # Obsidian's official CLI registers itself here on macOS.
        export PATH="/usr/local/bin:$PATH"

        # Homebrew (sets PATH, MANPATH, HOMEBREW_* env vars)
        if [ -x /opt/homebrew/bin/brew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '';
      shellAliases = {
        # ls = "exa";
        cf = "cabal --ghc-options=\"-j4 +RTS -A128m -n2m -qg -RTS\" --disable-optimization --disable-library-vanilla --enable-executable-dynamic";
        w = "wt switch --branches --remotes --prs";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins=["git" "macos" "brew" "fzf" "direnv"];
      };
      initContent =
        ''
        # Locale.
        LC_CTYPE=en_US.UTF-8
        LC_ALL=en_US.UTF-8

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

        # NOTE: ghcup:
        export PATH="$PATH:$HOME/.ghcup/bin"
        [ -f "/Users/james/.ghcup/env" ] && . "/Users/james/.ghcup/env" # ghcup-env

        # NOTE: python pip stuff:
        export PATH="$PATH:$HOME/Library/Python/3.9/bin"

        # Anthropic
        if [ -f "$HOME/.anthropic-api-key" ]; then
          export ANTHROPIC_API_KEY=$(cat $HOME/.anthropic-api-key)
        fi

        # OpenAI
        if [ -f "$HOME/.openai-api-key" ]; then
          export OPENAI_KEY=$(cat $HOME/.openai-api-key)
          export OPENAI_API_KEY=$(cat $HOME/.openai-api-key)
        fi

        # OpenRouter
        if [ -f "$HOME/.openrouter-api-key" ]; then
          # export OPENROUTER_API_KEY=$(cat $HOME/.openrouter-api-key)
        fi

        # Gemini
        if [ -f "$HOME/.gemini-api-key" ]; then
          # export GEMINI_API_KEY=$(cat $HOME/.gemini-api-key)
        fi

        # Aristotle
        if [ -f "$HOME/.aristotle-api-key" ]; then
          export ARISTOTLE_API_KEY=$(cat $HOME/.aristotle-api-key)          
        fi

        eval "$(wt config shell init zsh)"
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
      settings.user.name = "James Henri Haydon";
      settings.user.email = "james.haydon@gmail.com";
      ignores = [
        ".DS_Store"
        "**/.DS_Store"
        ".AppleDouble"
        ".LSOverride"
        ".direnv"
        "/.scratch/"
        "*.niu"
        ".local"
        "jhh"
        "jhh_*/"
      ];
      settings.alias = {
        emacs = "emacs -nw";
      };
      settings = {
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
        push.autoSetupRemote = "true";
      };
    };
  };
}
