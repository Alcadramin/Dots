{-
 - Copyright 2021 - Berkcan Ucan <hello@alca.dev> (alcadramin)
 - All colors based on Dracula Theme.
 -
 - https://gitlab.com/alcadramin/dotfiles
 -}

 -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

  -- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

 -- Data
import Data.Char (isSpace)
import Data.Monoid
import Data.Maybe (isJust, fromJust)
import Data.Tree
import qualified Data.Map as M

 -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (Direction1D(..), avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

 -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

 -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

 -- Prompt (Disabled)
{-
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)
-}

 -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)

  -------------------
  -- Configuration --
  -------------------

myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       -- Super/windows key

myTerminal :: String
myTerminal = "gnome-terminal"   -- Default terminal

myBrowser :: String
myBrowser = "firefox-developer-edition"

myEditor :: String
myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor for tree select but I'm not going to use tree select.

myBorderWidth :: Dimension
myBorderWidth = 2          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282a36" -- "#32302f"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#ffb86c" -- "#7EC8E3" "#e5df88"  -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

  ---------------
  -- Autostart --
  ---------------

myStartupHook :: X ()
myStartupHook = do
        -- spawnOnce "stretchly &"
        spawnOnce "nitrogen --restore &"
        spawnOnce "picom &"
        spawnOnce "volumeicon &"
        spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x282a36  --height 22 --monitor primary &"
        spawnOnce "xfce4-power-manager &"
        spawnOnce "numlockx on &"
        spawnOnce "nm-applet &"
        -- spawnOnce "/usr/bin/emacs --daemon &"
        -- spawnOnce "variety &"
        spawnOnce "/usr/libexec/polkitd &"
        -- spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
        spawnOnce "/usr/lib/xfce4/notifyd/xfce4-notifyd &"
        -- spawnOnce "tmux new &"
        setWMName "LG3D"

  -------------
  -- Layouts --
  -------------

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ mySpacing' 4
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           $ tabbed shrinkText myTabConfig
  where
    myTabConfig = def { fontName            = "xft:Mononoki Nerd Font:regular:pixelsize=11"
                      , activeColor         = "#282c34"
                      , inactiveColor       = "#3e445e"
                      , activeBorderColor   = "#282c34"
                      , inactiveBorderColor = "#282c34"
                      , activeTextColor     = "#ffffff"
                      , inactiveTextColor   = "#d0d0d0"
                      }

-- Theme for showWName which prints current workspace when you change workspaces. --

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Sans:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

  ---------------------
  -- Layout Hook --
  ---------------------

myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 -- ||| grid
                                 ||| noBorders tabs
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow

  --------------------------
  -- Clickable Workspaces --
  --------------------------

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces = [" www ", " dev ", " db ", " sys ", " chat ", " spotify ", " gfx ", " video ", " game "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

  -----------------
  -- Managehooks --
  -----------------

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out
     -- the full name of my workspaces.
     [ className =? "Gimp"    --> doShift ( myWorkspaces !! 8 )
     , className =? "Gimp"    --> doFloat
     -- , className =? "Blender" --> doFloat
     , className =? "Blender" --> doShift ( myWorkspaces !! 8 )
     , className =? "steam"   --> doFloat
     , className =? "jome"    --> doFloat
     , title =? "JetBrains Toolbox" --> doFloat
     , (title =? "RubyMine" <&&> resource =? "Dialog") --> doFloat
     , title =? "Steam"   --> doFloat
     , title =? "Friends List"  --> doFloat
     , className =? "steamwebhelper" --> doFloat
     , title =? "Oracle VM VirtualBox Manager"     --> doFloat
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox-developer-edition" <&&> resource =? "Dialog") --> doFloat
     , title =? "win0" --> doFloat
     , (className =? "jetbrains-clion" <&&> resource =? "Dialog"  --> doFloat)
     , (className =? "vivaldi" <&&> resource =? "Dialog") --> doFloat
     , isFullscreen --> doFullFloat
     ]

  ---------------------------------------------
  -- Loghook. (Opacity for inactive windows) --
  ---------------------------------------------

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

  -----------------
  -- Keybindings --
  -----------------

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-S-r", spawn "xmonad --recompile && xmonad --restart")      -- Recompiles && restarts xmonad
        , ("M-S-e", io exitSuccess)                                      -- Quits xmonad
        -- , ("M-S-x", spawn "xdg-screensaver lock")
        , ("M-S-x", spawn "betterlockscreen --lock blur")
        , ("M-d", spawn "rofi -show drun")
        -- , ("M-d", spawn "dmenu_run -p 'Run: '")
    -- Open my preferred terminal
        , ("M-<Return>", spawn myTerminal)

    -- Windows
        , ("M-S-q", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                         -- Kill all windows on current workspace

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats"))       -- Toggles my 'floats' layout
        , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
        , ("M-S-<Delete>", sinkAll)                      -- Push ALL floating windows to tile

    -- Windows navigation
        , ("M-m", windows W.focusMaster)     -- Move focus to the master window
        , ("M-j", windows W.focusDown)       -- Move focus to the next window
        , ("M-k", windows W.focusUp)         -- Move focus to the prev window
        --, ("M-S-m", windows W.swapMaster)    -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)      -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)        -- Swap focused window with prev window
        , ("M-<Backspace>", promote)         -- Moves focused window to master, others maintain order
        , ("M1-S-<Tab>", rotSlavesDown)      -- Rotate all windows except master and keep focus in place
        , ("M1-C-<Tab>", rotAllDown)         -- Rotate all the windows in the current stack
        --, ("M-S-s", windows copyToAll)
        , ("M-C-s", killAllOtherCopies)

        -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)         -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)      -- Toggles noborder
        , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
        , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane
        , ("M-S-<KP_Multiply>", increaseLimit)              -- Increase number of windows
        , ("M-S-<KP_Divide>", decreaseLimit)                -- Decrease number of windows

        , ("M-h", sendMessage Shrink)                       -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                       -- Expand horiz window width
        , ("M-C-j", sendMessage MirrorShrink)               -- Shrink vert window width
        , ("M-C-k", sendMessage MirrorExpand)               -- Exoand vert window width

    -- Workspaces
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Emacs (CTRL-e followed by a key) I currently use nVim so don't need theese keybindings.
        , ("C-e e", spawn "emacs")
        --, ("C-e e", spawn "emacsclient -c -a 'emacs'")                            -- start emacs
        --, ("C-e d", spawn "emacsclient -c -a '' --eval '(dired nil)'")       -- dired emacs file manager
        --, ("C-e i", spawn "emacsclient -c -a '' --eval '(erc)'")             -- erc emacs irc client

    --- My Applications (Super+Shift+Key)
        , ("M-S-<F1>", spawn "firefox-developer-edition")
        , ("M-S-<F2>", spawn "pcmanfm")
        , ("M-S-<F3>", spawn "discord --no-sandbox")
        --, ("M-y", spawn "jome -n | xclip -selection clipboard")
        , ("M-y", spawn "rofimoji --action copy")

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioMute>",   spawn "pactl set-sink-mute 1 toggle") 
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 1 -5%")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 1 +5%")
        , ("<Print>", spawn "flameshot gui")
        ]
           where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                 nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

  ----------
  -- Main --
  ----------

main :: IO ()
main = do
    -- Launching 2 instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobar.monitor1.hs"
    xmproc1 <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobar.monitor2.hs"
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        , handleEventHook    = handleEventHook defaultConfig <+> fullscreenEventHook 
                               <+> docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP

          -- Xmobar Config
          { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x
          , ppCurrent = xmobarColor "#f1fa8c" "" . wrap "<box type=Bottom width=2 mb=2 color=#f1fa8c>" "</box>"         -- Current workspace
          , ppVisible = xmobarColor "#f1fa8c" "" . clickable              -- Visible but not current workspace
          , ppHidden = xmobarColor "#bd93f9" "" . wrap "<box type=Bottom width=2 mt=2 color=#bd93f9>" "</box>" . clickable -- Hidden workspaces
          , ppHiddenNoWindows = xmobarColor "#b3afc2" ""  . clickable     -- Hidden workspaces (no windows)
          , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
          , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
          , ppUrgent = xmobarColor "##ff5555" "" . wrap "!" "!"            -- Urgent workspace
          , ppExtras  = [windowCount]                                     -- # of windows current workspace
          , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
          }

          -- WIP (Broken don't use it)
          {- ppOutput          = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
          , ppCurrent         = xmobarColor "#98be65" ""
          , ppVisible         = xmobarColor "#98be65" ""
          , ppHidden          = xmobarColor "#82aaff" ""
          , ppHiddenNoWindows = \s -> ""
          , ppLayout          = xmobarColor "#BBBBBB" "" . wrap "<fn=1>" " </fn>"
          , ppSep             = "<fn=1><fc=#666666> | </fc></fn>"
          , ppUrgent          = xmobarColor "#c45500" ""
          , ppWsSep           = " "
          , ppOrder           = \(ws:l:t:ex) -> [ws,l] -- ++ [t] -- order of things in xmobar : workspaces, layout, title
          -}

          -- Old one
          {- ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x
          , ppCurrent = xmobarColor "#98be65" "" . wrap "{" "}" -- Current workspace in xmobar
          , ppVisible = xmobarColor "#98be65" ""                -- Visible but not current workspace
          , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
          , ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
          , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
          , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"          -- Separators in xmobar
          , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
          , ppExtras  = [windowCount]                           -- # of windows current workspace
          , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
          -}
        } `additionalKeysP` myKeys
