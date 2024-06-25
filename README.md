# git-autocomplete-for-windows

A lightweight auto-completion for Git commands and branches in the Windows command prompt (cmd).

- Install [Clink](https://chrisant996.github.io/clink/) (Bash features for Windows)
- Copy [git-autocomplete.lua](https://github.com/ztomm/git-autocomplete-for-windows/blob/main/git-autocomplete.lua) into `C:\Users\<username>\AppData\local\clink`

I prefer to disable the `Use enhanced default settings` when installing Clink. This causes the suggestions to be displayed as a list on a double tab. A list can also be displayed with `CTRL+SPACE`.

Missing commands can be added in the git-autocomplete.lua (line 1-14).