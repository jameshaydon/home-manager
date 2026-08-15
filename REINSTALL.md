# Replacement Mac reinstall checklist

Captured from the returning Mac on 2026-08-15.

## Declarative installs

- [ ] Install Nix and apply this Home Manager flake. It installs the command-line
      environment, Obsidian, and iTerm2.
- [ ] Install Homebrew and run `brew bundle --file ./Brewfile`. This restores the
      six explicitly installed formulae, Codex, Emacs, Handy, Maccy, VLC, and
      Iosevka.
- [ ] Run `zsh macos/defaults.sh`, log out and back in, and verify the settings in
      `macos/README.md`.

## Applications outside Home Manager and Homebrew

These applications were present in `/Applications` and need a fresh download,
App Store installation, or account-managed installer if they are still wanted:

- [ ] ChatGPT
- [ ] Claude
- [ ] Firefox
- [ ] Google Drive
- [ ] Linear
- [ ] Logseq
- [ ] MATLAB R2025b
- [ ] Private Internet Access
- [ ] Proton Mail
- [ ] Slack
- [ ] Transmission
- [ ] Visual Studio Code
- [ ] Xcode
- [ ] Zoom

Also installed, but lower priority or easy to recreate:

- [ ] Google Chrome; do not migrate its profile.
- [ ] Google Docs, Sheets, and Slides browser applications.
- [ ] Inkscape
- [ ] Luniistore
- [ ] Opera
- [ ] Wolfram Player
- [ ] Keynote, Numbers, Pages, and iMovie from the App Store.
- [ ] Docker Desktop, if needed; do not migrate its state.
- [ ] Signal, if needed; reinstall and relink rather than migrating its state.

`Proton Mail Uninstaller.app` and `Claude Code URL Handler.app` are support
applications and do not require separate installation.

## Fonts

- [ ] Install Iosevka through the `Brewfile`.
- [ ] Restore `NFM.ttf` and `NotoSansJP-VariableFont_wght.ttf` from a private
      backup, or replace them with equivalent Nix or Homebrew packages.

## First-launch and account work

- [ ] Launch Handy once and grant Microphone and Accessibility access.
- [ ] Sign in to Firefox, run Sync, and verify bookmarks, passwords, history,
      add-ons, and settings. Do not migrate Chrome profile data.
- [ ] Sign in to Google Drive and verify retained files before deleting the old
      machine.
- [ ] Re-authenticate licensed and account-based applications, including MATLAB,
      Private Internet Access, Proton Mail, Slack, and the AI applications.
- [ ] Restore wanted VS Code settings, iTerm2 preferences, and Maccy preferences;
      use `macos/README.md` as the reference.
- [ ] Grant Accessibility, Full Disk Access, notifications, microphone, and VPN
      permissions only when the corresponding application requests them.
