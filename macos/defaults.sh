#!/bin/zsh

set -euo pipefail

# Keyboard repeat.
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Dock and Finder.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -float 68
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Maccy 2.x. The popup shortcut is Shift-Command-C; pin and delete are
# Option-P and Option-Delete.
defaults write org.p0deje.Maccy KeyboardShortcuts_popup \
  -string '{"carbonModifiers":768,"carbonKeyCode":8}'
defaults write org.p0deje.Maccy KeyboardShortcuts_pin \
  -string '{"carbonModifiers":2048,"carbonKeyCode":35}'
defaults write org.p0deje.Maccy KeyboardShortcuts_delete \
  -string '{"carbonModifiers":2048,"carbonKeyCode":51}'
defaults write org.p0deje.Maccy windowSize -string '[450,800]'
defaults write org.p0deje.Maccy showFooter -bool true
defaults write org.p0deje.Maccy showSearch -bool true
defaults write org.p0deje.Maccy showTitle -bool true
defaults write org.p0deje.Maccy "NSStatusItem Visible Item-1" -bool false

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

echo "Applied stable macOS and Maccy defaults."
echo "Complete the manual settings in macos/README.md after logging in again."
