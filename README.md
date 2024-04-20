# Nixfiles

:snowflake: My personal [NixOS](https://nixos.org/) configuration.
It uses [Flakes](https://nixos.wiki/wiki/Flakes) under the hood.

## Installation

1. Clone this repo
1. Run `make system` to install the system level components
1. Run `make home` to install the user level components

## Update

1. Run `make update` to update the Flake lockfile
1. Run `make system` to update the system level components
1. Run `make home` to update the user level components

## Colors

The whole setup follows the [Tokyo Night](https://github.com/folke/tokyonight.nvim) color scheme.

| Purpose    | Color                                                                                                       |
| :--------- | :---------------------------------------------------------------------------------------------------------- |
| Foreground | ![#c0caf5](<https://images.placeholders.dev/?width=50&height=50&bgColor=%23c0caf5&textColor=rgba(0,0,0,0)>) |
| Background | ![#1a1b26](<https://images.placeholders.dev/?width=50&height=50&bgColor=%231a1b26&textColor=rgba(0,0,0,0)>) |
| Primary    | ![#bb9af7](<https://images.placeholders.dev/?width=50&height=50&bgColor=%23bb9af7&textColor=rgba(0,0,0,0)>) |
| Warning    | ![#e0af68](<https://images.placeholders.dev/?width=50&height=50&bgColor=%23e0af68&textColor=rgba(0,0,0,0)>) |
| Danger     | ![#f7768e](<https://images.placeholders.dev/?width=50&height=50&bgColor=%23f7768e&textColor=rgba(0,0,0,0)>) |

## Keybindings

| Function                  | Keys                                                    |
| :------------------------ | :------------------------------------------------------ |
| Open App Launcher         | `Super + Space`                                         |
| Open Terminal             | `Super + Enter`                                         |
| Focus Last Window         | `Super + Tab`                                           |
| Open Web Browser          | `Super + W`                                             |
| Kill Active Window        | `Super + Q`                                             |
| Toggle Fullscreen Window  | `Super + F`                                             |
| Toggle Floating Window    | `Super + S`                                             |
| Open Clipboard History    | `Super + C`                                             |
| Open Emoji Picker         | `Super + E`                                             |
| Open Color Picker         | `Super + P`                                             |
| Lock Screen               | `Super + Ctrl + Q`                                      |
| Open Empty Workspace      | `Super + N`                                             |
| Switch to Workspace       | `Super + [1-9]`                                         |
| Move Window to Workspace  | `Super + Shift + [1-9]`                                 |
| Switch to Scratchpad      | `Super + 0`                                             |
| Move Window to Scratchpad | `Super + Shift + 0`                                     |
| Switch to Window          | `Super + [hjkl]` or `Move Mouse`                        |
| Move Window               | `Super + Shift + [hjkl]` or `Super + Left Mouse Button` |
| Resize Window             | `Super + Right Mouse Button`                            |

## Terminal Commands

| Function            | Command |
| :------------------ | :------ |
| Open Text Editor    | `e`     |
| Open File Manager   | `f`     |
| Open Git Browser    | `g`     |
| Open System Monitor | `m`     |
| Open File           | `o`     |
| Open Task Manager   | `t`     |
