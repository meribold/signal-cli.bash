# signal-cli.bash

Two Bash scripts aiming to make [signal-cli][1] more convenient to use.  **Requires a
configuration file** at `$HOME/.config/signal/init.bash`.

## `signal-daemon`
Starts `signal-cli` in daemon mode and creates notifications for incoming messages using
`notify-send`.  I only tested it with the [dunst(1) notification daemon][2].

## `s`
Sends messages and optionally a screenshot of a region or window.  Screenshots are taken
using [maim(1)][3] and [slop][4].  Examples.

*   Send a message to one recipient or a group:

        s alvin "Curiouser and curiouser!"
        s family Heh
*   Send a message to multiple recipients:

        s alvin lukas "I summon entropy."
*   Query for a region or window, take a screenshot, and sent it and an optional message:

        s -s alvin "This message is optional."

## Example `~/.config/signal/init.bash`
It should look something like this.

```bash
# Path to the `signal-cli` executable.
signal_cli='signal-cli'

user='+990123456789'

# Declare as associative arrays.
declare -A contacts groups

contacts['alvin']='+119876543210'
contacts['tom']='+2201010101010'

groups['family']='aiHo/b6oCiet+ah6makoh6=='
groups['thundermonkey']='Zi0Eng2iHao8xiejaepahK=='
```

[1]: https://github.com/AsamK/signal-cli
[2]: https://github.com/dunst-project/dunst
[3]: https://github.com/naelstrof/maim
[4]: https://github.com/naelstrof/slop

<!-- vim: set tw=90 sts=-1 sw=4 et spell: -->
