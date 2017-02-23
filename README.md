# signal-cli.bash

Two Bash scripts aiming to make [signal-cli][1] more convenient to use.

## `signal-daemon`
Starts `signal-cli` in daemon mode and creates notifications for incoming messages using
`notify-send`.  I only tested it with the [dunst(1) notification daemon][2].

## `s`
Sends messages and optionally a screenshot of a region or window.  Screenshots are taken
using [maim(1)][3] and [slop][4].

[1]: https://github.com/AsamK/signal-cli
[2]: https://github.com/dunst-project/dunst
[3]: https://github.com/naelstrof/maim
[4]: https://github.com/naelstrof/slop

<!-- vim: set tw=90 sts=-1 sw=4 et spell: -->
