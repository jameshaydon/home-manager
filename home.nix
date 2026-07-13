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
    # pkgs.yt-dlp
    pkgs.jq
    pkgs.sqlite
    pkgs.signal-cli
    pkgs.obsidian

    # A simple util to serve a dir as a website
    # pkgs.nodePackages.serve
    pkgs.gh
    pkgs.tree

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
        hm = "run home-manager";
        # ls = "exa";
        cf = "cabal --ghc-options=\"-j4 +RTS -A128m -n2m -qg -RTS\" --disable-optimization --disable-library-vanilla --enable-executable-dynamic";
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

        

        _gwt_finish_worktree() {
          local repo_root="$1"
          local worktree_path="$2"

          cd "$worktree_path" || { echo "❌ Failed to cd into $worktree_path"; return 1; }

          _gwt_link_agent_dir "$repo_root" ".claude" settings.local.json
          _gwt_link_agent_dir "$repo_root" ".codex" "*"
          _gwt_link_agent_dir "$repo_root" ".pi" "*"

          # Symlink shared setup files and directories
          for f in CLAUDE.md AGENTS.md .envrc jhh; do
            if [[ -e "$repo_root/$f" ]]; then
              if [[ -e "$f" ]]; then
                echo "⚠️  $f already exists in worktree (skipping)"
              elif ln -s "$repo_root/$f" "$f"; then
                echo "✓ Symlinked $f"
              else
                echo "❌ Failed to symlink $f"
              fi
            fi
          done

          # Copy cabal.project.local files (may be in nested directories)
          while IFS= read -r -d "" cpl; do
            local rel="''${cpl#$repo_root/}"
            if [[ -e "$rel" ]]; then
              echo "⚠️  $rel already exists in worktree (skipping)"
            else
              mkdir -p "$(dirname "$rel")"
              if cp "$cpl" "$rel"; then
                echo "✓ Copied $rel"
              else
                echo "❌ Failed to copy $rel"
              fi
            fi
          done < <(find "$repo_root" -name "cabal.project.local" -not -path "*/dist-newstyle/*" -print0 2>/dev/null)

          echo ""
          echo "📁 Worktree: $(pwd)"
          for f in .claude .claude/settings.local.json .codex .pi CLAUDE.md AGENTS.md .envrc jhh; do
            [[ -e "$f" ]] && ls -la "$f" 2>&1 | sed 's/^/   /'
          done
          find . -name "cabal.project.local" -not -path "*/dist-newstyle/*" 2>/dev/null | while read -r f; do
            ls -la "$f" 2>&1 | sed 's/^/   /'
          done
          echo ""

          if [[ -f ".envrc" ]]; then
            echo "🔧 Setting up direnv..."
            direnv allow
          fi
        }

        _gwt_existing_worktree_path() {
          local branch="$1"
          local worktree_path=""
          local expected_branch="branch refs/heads/$branch"

          while IFS= read -r line; do
            if [[ "$line" == worktree\ * ]]; then
              worktree_path="''${line#worktree }"
            elif [[ "$line" == "$expected_branch" ]]; then
              echo "$worktree_path"
              return 0
            fi
          done < <(git worktree list --porcelain)

          return 1
        }

        _gwt_pick_branch() {
          local sep=$'\x1f'
          local worktree_path=""
          local branch=""
          local remote_ref=""
          local remote=""

          {
            while IFS= read -r line; do
              if [[ "$line" == worktree\ * ]]; then
                worktree_path="''${line#worktree }"
              elif [[ "$line" == branch\ refs/heads/* ]]; then
                branch="''${line#branch refs/heads/}"
                printf "worktree%s%s%s%s%s%s%s\n" "$sep" "$branch" "$sep" "$branch" "$sep" "$sep" "$worktree_path"
              fi
            done < <(git worktree list --porcelain)

            git for-each-ref --format="%(refname:short)" refs/heads | while IFS= read -r branch; do
              if ! _gwt_existing_worktree_path "$branch" >/dev/null; then
                printf "local%s%s%s%s%s\n" "$sep" "$branch" "$sep" "$branch" "$sep$sep"
              fi
            done

            git for-each-ref --format="%(refname:short)" refs/remotes | while IFS= read -r remote_ref; do
              [[ "$remote_ref" == */HEAD ]] && continue

              remote="''${remote_ref%%/*}"
              branch="''${remote_ref#*/}"

              if ! _gwt_existing_worktree_path "$branch" >/dev/null; then
                printf "remote%s%s%s%s%s%s%s\n" "$sep" "$remote_ref" "$sep" "$branch" "$sep" "$remote" "$sep"
              fi
            done
          } | fzf \
            --height=40% \
            --reverse \
            --prompt="gotree> " \
            --delimiter="$sep" \
            --with-nth=1,2,5
        }

        _gwt_link_agent_dir() {
          local repo_root="$1"
          local dir="$2"
          shift 2

          if [[ ! -e "$repo_root/$dir" ]]; then
            return 0
          fi

          if [[ ! -e "$dir" ]]; then
            if ln -s "$repo_root/$dir" "$dir"; then
              echo "✓ Symlinked $dir"
            else
              echo "❌ Failed to symlink $dir"
            fi
            return 0
          fi

          if [[ -L "$dir" ]]; then
            echo "⚠️  $dir already exists in worktree (skipping)"
            return 0
          fi

          if [[ ! -d "$dir" || ! -d "$repo_root/$dir" ]]; then
            echo "⚠️  $dir already exists in worktree (skipping)"
            return 0
          fi

          # Some repos commit project files under agent config directories. In
          # that case, keep the checked-out directory and share missing entries.
          if [[ "$1" == "*" ]]; then
            shift
            set -- "$repo_root/$dir"/*(N) "$repo_root/$dir"/.[!.]*(N) "$repo_root/$dir"/..?*(N)
          fi

          for src in "$@"; do
            local src_path="$src"
            local f=""

            if [[ "$src" == "$repo_root/$dir/"* ]]; then
              [[ -e "$src_path" ]] || continue
              f="''${src_path#$repo_root/$dir/}"
            else
              src_path="$repo_root/$dir/$src"
              f="$src"
            fi

            if [[ -e "$src_path" ]]; then
              if [[ -e "$dir/$f" ]]; then
                echo "⚠️  $dir/$f already exists in worktree (skipping)"
              elif ln -s "$src_path" "$dir/$f"; then
                echo "✓ Symlinked $dir/$f"
              else
                echo "❌ Failed to symlink $dir/$f"
              fi
            fi
          done
        }

        gotree() {
          local input="$1"
          local second_arg="$2"

          if [[ -z "$input" ]]; then
            if ! command -v fzf >/dev/null 2>&1; then
              echo "Usage: gotree [branch-name] [base-branch-or-remote]"
              echo "❌ fzf is not available for interactive branch selection"
              return 1
            fi

            local selection
            selection=$(_gwt_pick_branch) || return 1

            local selection_kind selection_label selection_branch selection_remote selection_path
            IFS=$'\x1f' read -r selection_kind selection_label selection_branch selection_remote selection_path <<< "$selection"

            case "$selection_kind" in
              worktree)
                cd "$selection_path" || { echo "❌ Failed to cd into $selection_path"; return 1; }
                echo ""
                echo "📁 Worktree: $(pwd)"
                return 0
                ;;
              local)
                input="$selection_branch"
                ;;
              remote)
                input="$selection_branch"
                second_arg="$selection_remote"
                ;;
              *)
                return 1
                ;;
            esac
          fi

          local branch="$input"
          local base="''${second_arg:-main}"
          local remote="origin"
          local remote_requested=0

          if [[ "$input" == */* ]]; then
            local maybe_remote="''${input%%/*}"
            local maybe_branch="''${input#*/}"
            if git remote get-url "$maybe_remote" >/dev/null 2>&1; then
              remote="$maybe_remote"
              branch="$maybe_branch"
              remote_requested=1
            fi
          fi

          if [[ -n "$second_arg" ]] && git remote get-url "$second_arg" >/dev/null 2>&1; then
            remote="$second_arg"
            base="main"
            remote_requested=1
          fi

          local repo_root=$(git rev-parse --show-toplevel)
          local repo_name=$(basename "$repo_root")
          local worktree_path="../''${repo_name}-''${branch}"
          local remote_ref="''${remote}/''${branch}"
          local local_ref="refs/heads/''${branch}"

          local existing_worktree_path
          if existing_worktree_path=$(_gwt_existing_worktree_path "$branch"); then
            cd "$existing_worktree_path" || { echo "❌ Failed to cd into $existing_worktree_path"; return 1; }
            echo ""
            echo "📁 Worktree: $(pwd)"
            return 0
          fi

          if git fetch "$remote" "refs/heads/''${branch}:refs/remotes/''${remote}/''${branch}" >/dev/null 2>&1; then
            if git show-ref --verify --quiet "$local_ref"; then
              local local_commit=$(git rev-parse "$local_ref")
              local remote_commit=$(git rev-parse "$remote_ref")

              if [[ "$local_commit" != "$remote_commit" ]]; then
                if git merge-base --is-ancestor "$local_ref" "$remote_ref"; then
                  if git branch -f "$branch" "$remote_ref" >/dev/null; then
                    echo "✓ Fast-forwarded local branch '$branch' to '$remote_ref'"
                  else
                    echo "❌ Failed to update local branch '$branch'"
                    return 1
                  fi
                else
                  echo "❌ Local branch '$branch' is not a fast-forward of '$remote_ref'"
                  echo "   Local:  $(git rev-parse --short "$local_ref")"
                  echo "   Remote: $(git rev-parse --short "$remote_ref")"
                  return 1
                fi
              fi

              git branch --set-upstream-to="$remote_ref" "$branch" >/dev/null 2>&1

              if git worktree add "$worktree_path" "$branch"; then
                echo "✓ Created worktree for '$branch' at '$remote_ref'"
              else
                echo "❌ Failed to create worktree for '$branch'"
                return 1
              fi
            elif git worktree add "$worktree_path" -b "$branch" "$remote_ref"; then
              if git branch --set-upstream-to="$remote_ref" "$branch" >/dev/null; then
                echo "✓ Created worktree for remote branch '$remote_ref'"
              else
                echo "❌ Failed to set upstream for '$branch' to '$remote_ref'"
                return 1
              fi
            else
              echo "❌ Failed to create worktree for remote branch '$remote_ref'"
              return 1
            fi
          elif [[ "$remote_requested" -eq 1 ]]; then
            echo "❌ Failed to fetch '$branch' from '$remote'"
            return 1
          elif git worktree add "$worktree_path" -b "$branch" "$base" 2>/dev/null; then
            echo "✓ Created worktree with new branch '$branch' from '$base'"
          elif git worktree add "$worktree_path" "$branch"; then
            echo "✓ Created worktree for existing branch '$branch'"
          else
            echo "❌ Failed to create worktree"
            return 1
          fi

          _gwt_finish_worktree "$repo_root" "$worktree_path"
        }
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
