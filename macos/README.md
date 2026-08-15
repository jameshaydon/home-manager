# macOS and application preferences

Captured from the returning Mac on 2026-08-15. Run `zsh macos/defaults.sh` to
apply the stable preferences. The settings below are recorded for manual setup
because their preference representation is opaque, tied to an application
profile, or liable to change between macOS versions.

## Captured by the script

- Keyboard: `InitialKeyRepeat=15`, `KeyRepeat=2`.
- Dock: auto-hide enabled, tile size 68.
- Finder: path bar and status bar enabled.
- Maccy 2.x: Shift-Command-C opens the popup, Option-P pins, Option-Delete
  deletes, the window is 450 by 800, the title/search/footer are visible, and
  the menu-bar icon is hidden.

## Manual application preferences

- iTerm2 default profile: Iosevka Term 13, 80 columns by 25 rows, 1,000 lines of
  scrollback, visual bell enabled, and terminal type `xterm-256color`.
- Maccy should launch at login. Confirm the popup shortcut after granting any
  requested Accessibility permission.

## Keyboard and input sources

The selected input source is the ABC keyboard layout. The enabled sources were
ABC, Japanese Romaji input, Character Viewer, the Japanese character palette,
and Press and Hold. Reconfigure these through **System Settings -> Keyboard ->
Text Input** instead of writing the private `com.apple.HIToolbox` preference
domain.

The complete `AppleSymbolicHotKeys` value is retained in
`symbolic-hotkeys.json`. Use it as a comparison reference in **System Settings
-> Keyboard -> Keyboard Shortcuts**. Do not import it wholesale on a different
macOS release: the numeric identifiers are private and can change.

## Dock contents

The Dock contained Apps, Calendar, Firefox, Opera, App Store, System Settings,
Terminal, Emacs, and Slack, followed by the Downloads stack. Rebuild it manually
after installing the applications; its serialized bookmarks are deliberately
not copied.

## Protected settings

Accessibility, Full Disk Access, Microphone, notifications, VPN permissions,
login items, and similar protected state must be granted manually. In
particular, Handy needs Microphone and Accessibility access, and Private
Internet Access needs VPN permission.
