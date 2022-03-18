Config
  { font = "xft:Ubuntu Nerd Font:weight=bold:pixelsize=11:antialias=true:hinting=true",
    additionalFonts =
      [ "xft:SauceCodePro Nerd Font:pixelsize=11:antialias=true:hinting=true"
      , "xft:SauceCodePro Nerd Font:pixelsize=12:antialias=true:hinting=true"
      , "xft:FontAwesome:pixelsize=12"
      ],
    bgColor = "#282a36",
    fgColor = "#eff0eb",
    alpha = 255,
    position = Static {xpos = 1920, ypos = 0, width = 1920, height = 24},
    textOffset = -1,
    iconOffset = -1,
    allDesktops = True,
    persistent = True,
    iconRoot = "/home/alcadramin/.xmonad/xpm/",
    commands =
      [ Run UnsafeStdinReader,
        Run Date "<fn=2>\xf017 </fn>  %b %d %Y - (%H:%M) " "date" 50,
        Run Network "wlp2s0" ["-t", "<fn=2>\xf0ab </fn> <rx>kb  <fn=2>\xf0aa </fn> <tx>kb"] 20,
        Run Cpu ["-t", "<fn=2>\xf108 </fn>  cpu: (<total>%)","-H","50","--high","red"] 20,
        Run Memory ["-t", "<fn=2>\xf233 </fn>  mem: <used>M (<usedratio>%)"] 20,
        Run DiskU [("/", "<fn=2>\xf0c7 </fn>  hdd: <free> free")] [] 60,
        Run Com "uname" ["-r"] "" 3600,
        Run Com "/home/alcadramin/.local/bin/battery.sh" [""] "bat" 50,
        Run Com "/home/alcadramin/.local/bin/layout.sh" [""] "layout" 50,
        Run Com "/home/alcadramin/.local/bin/trayerpad.sh" [] "trayerpad" 20,
        Run Com "/home/alcadramin/.local/bin/debupdate.sh" [] "debupdate" 36000,
        Run Com "echo" ["<fn=3>\xf17c</fn>"] "penguin" 3600
      ],
    sepChar = "%",
    alignSep = "}{",
    template = " <icon=haskell_20.xpm/>   <fc=#666666>|</fc> %UnsafeStdinReader% }{   \
               \<box type=Bottom width=2 mb=2 color=#51afef><fc=#51afef>%penguin%  <action=`gnome-terminal -e htop`>%uname%</action> </fc></box>   \
               \<box type=Bottom width=2 mb=2 color=#ecbe7b><fc=#ecbe7b><action=`gnome-terminal -e htop`>%cpu%</action></fc></box>   \
               \<box type=Bottom width=2 mb=2 color=#ff6c6b><fc=#ff6c6b><action=`gnome-terminal -e htop`>%memory%</action></fc></box>    \
               \<box type=Bottom width=2 mb=2 color=#a9a1e1><fc=#a9a1e1><action=`gnome-terminal -e htop`>%disku%</action></fc></box>   \
               \<box type=Bottom width=2 mb=2 color=#98be65><fc=#98be65><action=`gnome-terminal -e htop`>%wlp2s0%</action></fc></box>   \
               \<box type=Bottom width=2 mb=2 color=#c678dd><fc=#c678dd> updates: <action=`gnome-terminal -e sudo apt update && sudo apt upgrade`>%debupdate%</action></fc></box>   \
               \<box type=Bottom width=2 mb=2 color=#46d9ff><fc=#46d9ff><action=`gnome-calendar`>%date%</action></fc></box>   \
               \<box type=Bottom width=2 mb=2 color=#ffffff><fc=#ffffff>%bat%    %layout%</fc></box>  %trayerpad%"

  }
