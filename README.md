# signal-cli.bash

Two Bash scripts aiming to make [`signal-cli`][1] convenient for interactive use.

## `signal-daemon`
Starts `signal-cli` in daemon mode and creates notifications for incoming messages using
`notify-send`.  I only tested it with the [`dunst(1)`][2] notification daemon.

![Dunst message window screenshot](/../screenshots/notification.png?raw=true "Dunst message window screenshot")

## `s`
Sends messages and optionally a screenshot of a region or window.  Screenshots are taken
using [`maim(1)`][3] and [`slop(1)`][4].  Requires that `signal-cli` is running in daemon
mode (via `signal-daemon` or directly).  Examples.

*   Send messages to one recipient or a group:
    ```bash
    s alvin "Curiouser and curiouser!"
    s family Heh
    fortune -s | s alvin
    ```

*   Send a message to multiple recipients:
    ```bash
    s alvin lukas "I summon entropy."
    ```

*   Query for a region or window, take a screenshot, and send it and an optional message:
    ```bash
    s -s alvin "This message is optional."
    ```

![GIF demonstrating the -s option](/../screenshots/s-option.gif?raw=true "GIF demonstrating the -s option")

## Installation

1.  Put the two scripts somewhere in your `$PATH`.  For example `~/bin/`:
    ```bash
    curl -fLo ~/bin/signal-daemon --create-dirs \
        https://raw.githubusercontent.com/meribold/signal-cli.bash/master/signal-daemon
    curl -fLo ~/bin/s --create-dirs \
        https://raw.githubusercontent.com/meribold/signal-cli.bash/master/s
    ```

2.  Create a configuration file with your phone number and aliases for your contacts and
    groups at `~/.config/signal/init.bash`.  It should look something like this.

    ```bash
    # Path to the `signal-cli` executable, if the directory is not in "$PATH".
    # signal_cli="$HOME/signal-cli-0.5.6/bin/signal-cli"

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
