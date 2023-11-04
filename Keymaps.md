# Keymaps

## Terminal

wezterm **\<leader\>** key = <kbd>Ctrl + a</kbd>

| Keybind                                               | Action                                                                                           | Process  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------ | -------- |
| <kbd>Ctrl + a </kbd>                                  | jump to beginning of line                                                                        | fish     |
| <kbd>Ctrl + e </kbd>                                  | jump to end of line                                                                              | fish     |
| <kbd>Ctrl + b </kbd> <kbd>Ctrl + f </kbd>             | move backwards/forward character wise                                                            | fish     |
| <kbd>Alt + ← </kbd> <kbd>Alt + → </kbd>               | move backwards/forward word wise                                                                 | fish     |
| <kbd>Ctrl + k </kbd>                                  | delete from cursor to end of line                                                                | fish     |
| <kbd>Ctrl + u </kbd>                                  | delete from cursor to beginning of line                                                          | fish     |
| <kbd>Alt + d </kbd>                                   | delete next word                                                                                 | fish     |
| <kbd>Alt + w </kbd>                                   | print description of command under cursor                                                        | fish     |
| <kbd>Alt + c </kbd>                                   | capitalise current word under cursor                                                             | fish     |
| <kbd>Alt + u </kbd>                                   | make uppercase current word under cursor                                                         | fish     |
| <kbd>Alt + s </kbd>                                   | add sudo to last command                                                                         | fish     |
| <kbd>Ctrl + l </kbd>                                  | clear screen                                                                                     | fish     |
| <kbd>Ctrl + Alt + f </kbd>                            | search directory                                                                                 | fzf.fish |
| <kbd>Ctrl + Alt + l </kbd>                            | git log                                                                                          | fzf.fish |
| <kbd>Ctrl + Alt + s </kbd>                            | git status                                                                                       | fzf.fish |
| <kbd>Ctrl + r </kbd>                                  | search history                                                                                   | fzf.fish |
| <kbd>Ctrl + Alt + p </kbd>                            | search processes                                                                                 | fzf.fish |
| <kbd>Ctrl + v </kbd>                                  | search variables                                                                                 | fzf.fish |
| <kbd>\<leader\> + K </kbd>                            | split window right                                                                               | wezterm  |
| <kbd>\<leader\> + L </kbd>                            | split window down                                                                                | wezterm  |
| <kbd>Ctrl + [h/j/k/l] </kbd>                          | move cursor to `[left/down/up/right]` window                                                     | wezterm  |
| <kbd>Alt + [h/j/k/l] </kbd>                           | resize window to the `[left/down/up/right]`                                                      | wezterm  |
| <kbd>\<leader\> + q </kbd>                            | close current window                                                                             | wezterm  |
| <kbd>\<leader\> + z </kbd>                            | toggle/untoggle window maximise                                                                  | wezterm  |
| <kbd>\<leader\> + r </kbd>                            | enter resize mode and resize with <kbd>h/j/k/l</kbd>, <kbd>Esc</kbd> or <kbd>Enter</kbd> to exit | wezterm  |
| <kbd>\<leader\> + t </kbd>                            | new tab                                                                                          | wezterm  |
| <kbd>\<leader\> + T </kbd>                            | close current tab                                                                                | wezterm  |
| <kbd>\<leader\> + [ </kbd> <kbd>\<leader\> + ] </kbd> | move to previous/next tab                                                                        | wezterm  |
| <kbd>\<leader\> + [1-9] </kbd>                        | move to tab with index n                                                                         | wezterm  |
| <kbd>\<leader\> + n </kbd>                            | show tab navigator                                                                               | wezterm  |
| <kbd>\<leader\> + W </kbd>                            | create new workspace                                                                             | wezterm  |
| <kbd>\<leader\> + w </kbd>                            | switch workspace                                                                                 | wezterm  |

## Awesome

| Keybind                                   | Action                                       | Group    |
| ----------------------------------------- | -------------------------------------------- | -------- |
| <kbd>ModKey + Enter </kbd>                | open a terminal                              | launcher |
| <kbd>ModKey + d </kbd>                    | rofi launcher                                | launcher |
| <kbd>ModKey + r </kbd>                    | rofi prompt                                  | launcher |
| <kbd>ModKey + p </kbd>                    | rofi power menu                              | launcher |
| <kbd>ModKey + Shift + s </kbd>            | show help with all keymaps                   | awesome  |
| <kbd>ModKey + Ctrl + r </kbd>             | restart awesome                              | awesome  |
| <kbd>ModKey + Shift + e </kbd>            | quit awesome                                 | awesome  |
| <kbd>ModKey + x </kbd>                    | run lua code                                 | awesome  |
| <kbd>ModKey + Left </kbd>                 | previous tag                                 | tag      |
| <kbd>ModKey + Right </kbd>                | next tag                                     | tag      |
| <kbd>ModKey + Shift + Left </kbd>         | move client to previous tag and switch to it | tag      |
| <kbd>ModKey + Shift + Right </kbd>        | move client to next tag and switch to it     | tag      |
| <kbd>ModKey + Esc </kbd>                  | go back to last tag                          | tag      |
| <kbd>ModKey + Shift + k </kbd>            | focus next screen                            | screen   |
| <kbd>ModKey + Shift + j </kbd>            | focus previous screen                        | screen   |
| <kbd>ModKey + k </kbd>                    | focus next client by index                   | client   |
| <kbd>ModKey + j </kbd>                    | focus previous client by index               | client   |
| <kbd>ModKey + u </kbd>                    | jump to urgent client                        | client   |
| <kbd>ModKey + Tab</kbd>                   | go back to last client                       | client   |
| <kbd>ModKey + Shift + n </kbd>            | restore minimized client                     | client   |
| <kbd>ModKey + Shift + j </kbd>            | swap with next client by index               | client   |
| <kbd>ModKey + Shift + k </kbd>            | swap with previous client by index           | client   |
| <kbd>ModKey + l</kbd>                     | increase client width                        | layout   |
| <kbd>ModKey + h</kbd>                     | decrease client width                        | layout   |
| <kbd>ModKey + Shift + l</kbd>             | increase number of clients                   | layout   |
| <kbd>ModKey + Shift + h</kbd>             | decrease number of clients                   | layout   |
| <kbd>ModKey + Alt + l</kbd>               | increase number of columns                   | layout   |
| <kbd>ModKey + Alt + h</kbd>               | decrease number of column                    | layout   |
| <kbd>ModKey + Space </kbd>                | select next layout                           | layout   |
| <kbd>ModKey + Shift + Space </kbd>        | select previous layout                       | layout   |
| <kbd>ModKey + [1-9] </kbd>                | view tag by index                            | tag      |
| <kbd>ModKey + Ctrl + [1-9] </kbd>         | focus tag by index                           | tag      |
| <kbd>ModKey + Shift + [1-9] </kbd>        | move focused client to tag                   | tag      |
| <kbd>ModKey + Ctrl + Shift + [1-9] </kbd> | toggle focused client on tag                 | tag      |
| <kbd>ModKey + Alt + [1-9] </kbd>          | select layout                                | tag      |
| <kbd>ModKey + f </kbd>                    | toggle fullscreen                            | client   |
| <kbd>ModKey + q </kbd>                    | close client                                 | client   |
| <kbd>ModKey + Ctrl + Space </kbd>         | toggle floating                              | client   |
| <kbd>ModKey + Ctrl + Enter </kbd>         | move to master                               | client   |
| <kbd>ModKey + o </kbd>                    | move to screen                               | client   |
| <kbd>ModKey + t </kbd>                    | toggle keep on top                           | client   |
| <kbd>ModKey + n </kbd>                    | minimize client                              | client   |
| <kbd>ModKey + z </kbd>                    | unmaximize client                            | client   |
