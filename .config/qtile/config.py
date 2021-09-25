# -*- coding: utf-8 -*-

##
# Author: bw3u <berkcan@vivaldi.net>
# Github: @bw3u
# Gitlab: @bw3u
# Reddit: @panlazy
#
# License: MIT

# Imports #

import os
import re
import socket
import subprocess
from libqtile import qtile
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List

# Defaults #

mod = "mod4"  # Setting mod key to "SUPER"
term = "kitty"  # Setting terminal to "kitty"
browser = "firefox-developer-edition"  # Setting browser to "Firefox Developer Edition"

# Keybindings #

keys = [
    Key([mod], "Return", lazy.spawn(term), desc="Launches default terminal"),
    Key(
        [mod],
        "d",
        lazy.spawn(
            "rofi -no-config -no-lazy-grab -show drun -modi drun -theme ~/.config/polybar/scripts/rofi/launcher.rasi"
        ),
        desc="Launches rofi",
    ),
    Key([mod], "y", lazy.spawn("rofimoji -a copy"), desc="Launches rofimoji"),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn(os.path.expanduser("~/.config/wofi/wofi-power.sh")),
        desc="Rofi powermenu",
    ),
    Key(
        [mod, "shift", "control"],
        "l",
        lazy.spawn("betterlockscreen -l"),
        desc="Lock screen",
    ),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"), # Didn't configured the bar properly, looks like shit.
    # Qtile controls
    Key([mod], "Tab", lazy.next_layout(), desc="Switch layout"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill active window"),
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Quit qtile"),
    # Workspace controls.
    Key([mod], "j", lazy.layout.down(), desc="Move focus down in current stack pane"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up in current stack pane"),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down(),
        desc="Move windows down in current stack",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up(),
        desc="Move windows up in current stack",
    ),
    Key(
        [mod],
        "h",
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc="Shrink window (MonadTall), decrease number in master pane (Tile)",
    ),
    Key(
        [mod],
        "l",
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc="Expand window (MonadTall), increase number in master pane (Tile)",
    ),
    Key([mod], "n", lazy.layout.normalize(), desc="normalize window size ratios"),
    Key(
        [mod],
        "m",
        lazy.layout.maximize(),
        desc="toggle window between minimum and maximum sizes",
    ),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    ### Stack controls
    Key(
        [mod, "shift"],
        "Tab",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc="Switch which side main pane occupies (XMonadTall)",
    ),
    Key(
        [mod],
        "space",
        lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack",
    ),
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Emacs keybindings, CTRL+e -> 'key'.
    KeyChord(
        ["control"],
        "e",
        [
            Key([], "e", lazy.spawn("emacs"), desc="Launch Emacs"),
        ],
    ),
    # Application keybindings
    Key([mod, "shift"], "d", lazy.spawn("pcmanfm"), desc="Launch PCManFM"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Screenshot"),
    # Media Keys
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
    ),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
    ),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
]


groups = [
    Group("1", label="", spawn="firefox-developer-edition"),
    Group("2", label=""),
    Group("3", label=""),
    Group("4", label=""),
    Group("5", label=""),
    Group("6", label=""),
    Group("7", label=""),
    Group("8", label="﵂"),
    Group(
        "9",
        label="",
        matches=[
            Match(wm_class=["zoom"]),
        ],
    ),
    Group("0", label=""),
]

for i in range(len(groups)):
    keys.append(Key([mod], str((i)), lazy.group[str(i)].toscreen()))
    keys.append(
        Key([mod, "shift"], str((i)), lazy.window.togroup(str(i), switch_group=True))
    )

# Navy and Ivory based. (["main color", "if diff. will be 2nd color which will be gradient"])
colors = [
    ["#021b21", "#021b21"],  # 0
    ["#032c36", "#065f73"],  # 1
    # ["#032c36", "#61778d"],# 1 this one is bit lighter
    ["#e8dfd6", "#e8dfd6"],  # 2
    ["#c2454e", "#c2454e"],  # 3
    ["#44b5b1", "#44b5b1"],  # 4
    ["#9ed9d8", "#9ed9d8"],  # 5
    ["#f6f6c9", "#f6f6c9"],  # 6
    ["#61778d", "#61778d"],  # 7
    ["#e2c5dc", "#e2c5dc"],  # 8
    ["#5e8d87", "#5e8d87"],  # 9
    ["#032c36", "#032c36"],  # 10
    ["#2e3340", "#2e3340"],  # 11
    ["#065f73", "#065f73"],  # 12
    ["#8a7a63", "#8a7a63"],  # 13
    ["#beb090", "#beb090"],  # 14
    ["#7cbf9e", "#7cbf9e"],  # 15
    ["#a2d9b1", "#a2d9b1"],  # 16
]

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": "#e8dfD6",
    "border_normal": "#021b21",
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Stack(num_stacks=2),
    layout.RatioTile(**layout_theme),
    layout.Floating(**layout_theme),
]


# Widgets #

widget_defaults = dict(
    font="Inconsolata for powerline",
    fontsize=10,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    padding=6,
                    linewidth=0,
                    background=colors[6],
                ),
                widget.TextBox(
                    text="  ",
                    font="Iosevka Nerd Font",
                    fontsize="18",
                    background=colors[6],
                    foreground=colors[0],
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("xmenu.sh")},
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[6],
                    foreground=colors[0],
                ),
                widget.GroupBox(
                    font="Ubuntu Nerd Font",
                    fontsize=16,
                    margin_y=3,
                    margin_x=6,
                    padding_y=7,
                    padding_x=6,
                    borderwidth=4,
                    active=colors[8],
                    inactive=colors[1],
                    rounded=False,
                    highlight_color=colors[3],
                    highlight_method="block",
                    this_current_screen_border=colors[6],
                    block_highlight_text_color=colors[0],
                ),
                widget.Prompt(
                    background=colors[2],
                    foreground=colors[0],
                    font="Iosevka Nerd Font",
                    fontsize=18,
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize=33,
                    padding=0,
                    background=colors[0],
                    foreground=colors[2],
                ),
                widget.WindowName(
                    font="Iosevka Nerd Font",
                    fontsize=15,
                    background=colors[2],
                    foreground=colors[0],
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[2],
                    foreground=colors[0],
                ),
                widget.Spacer(length=300),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[0],
                    foreground=colors[10],
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    scale=0.45,
                    padding=0,
                    background=colors[10],
                    foreground=colors[2],
                    font="Iosevka Nerd Font",
                    fontsize=14,
                ),
                widget.CurrentLayout(
                    font="Iosevka Nerd Font",
                    fontsize=15,
                    background=colors[10],
                    foreground=colors[2],
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[10],
                    foreground=colors[11],
                ),
                widget.TextBox(
                    text=" ",
                    font="Iosevka Nerd Font",
                    fontsize=18,
                    padding=0,
                    background=colors[11],
                    foreground=colors[2],
                ),
                widget.DF(
                    fmt=" {}",
                    font="Iosevka Nerd Font",
                    fontsize=15,
                    partition="/home",
                    format="{uf}{m} ({r:.0f}%)",
                    visible_on_warn=False,
                    background=colors[11],
                    foreground=colors[2],
                    padding=5,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("st -e storage.sh")
                    },
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[11],
                    foreground=colors[12],
                ),
                widget.TextBox(
                    text=" ",
                    font="Iosevka Nerd Font",
                    fontsize=16,
                    foreground=colors[2],
                    background=colors[12],
                    padding=0,
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("st -e htop")},
                ),
                widget.Memory(
                    background=colors[12],
                    foreground=colors[2],
                    font="Iosevka Nerd Font",
                    fontsize=15,
                    format="{MemUsed: .0f} MB",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("st -e htop")},
                ),
                widget.Sep(
                    padding=8,
                    linewidth=0,
                    background=colors[12],
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[12],
                    foreground=colors[7],
                ),
                widget.Sep(
                    padding=6,
                    linewidth=0,
                    background=colors[7],
                ),
                widget.Systray(
                    background=colors[7],
                    foreground=colors[2],
                    icons_size=18,
                    padding=4,
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[7],
                    foreground=colors[13],
                ),
                widget.TextBox(
                    text="墳 ",
                    font="Iosevka Nerd Font",
                    fontsize=18,
                    background=colors[13],
                    foreground=colors[0],
                ),
                widget.Volume(
                    background=colors[13],
                    foreground=colors[0],
                    font="Iosevka Nerd Font",
                    fontsize=15,
                    mouse_callbacks={
                        "Button3": lambda: qtile.cmd_spawn("st -e pulsemixer")
                    },
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[13],
                    foreground=colors[15],
                ),
                widget.TextBox(
                    text="  ",
                    font="Iosevka Nerd Font",
                    fontsize="14",
                    padding=0,
                    background=colors[15],
                    foreground=colors[0],
                ),
                widget.Clock(
                    font="Iosevka Nerd Font",
                    foreground=colors[0],
                    background=colors[15],
                    fontsize=15,
                    format="%d %b, %A",
                ),
                widget.Sep(
                    padding=6,
                    linewidth=0,
                    background=colors[15],
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[15],
                    foreground=colors[16],
                ),
                widget.TextBox(
                    text=" ",
                    font="Iosevka Nerd Font",
                    fontsize="18",
                    padding=0,
                    background=colors[16],
                    foreground=colors[0],
                ),
                widget.Clock(
                    font="Iosevka Nerd Font",
                    foreground=colors[0],
                    background=colors[16],
                    fontsize=15,
                    format="%I:%M %p",
                ),
                widget.TextBox(
                    text="\ue0be",
                    font="Inconsolata for powerline",
                    fontsize="33",
                    padding=0,
                    background=colors[16],
                    foreground=colors[6],
                ),
                widget.Sep(
                    padding=6,
                    linewidth=0,
                    background=colors[6],
                ),
            ],
            28,
            opacity=0.95,
            background=colors[0],
            margin=[8, 8, 0, 8],
        ),
        # left=bar.Gap(5),
        # right=bar.Gap(5),
    ),
]

# Helper functions #
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


# Mod + Mouse drag -> Floating
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        # default_float_rules include: utility, notification, toolbar, splash, dialog,
        # file_progress, confirm, download and error.
        *layout.Floating.default_float_rules,
        Match(title="Confirmation"),
        Match(title="Qalculate!"),
        Match(wm_class="OBS"),
        Match(wm_class="MultiMC"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/boot.sh"])
