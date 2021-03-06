{--------------------------------------------------------------------------------
 Copyright (c) Daan Leijen 2003
 Copyright (c) Jeremy O'Donoghue 2008
 wxWindows License.

 Demonstrates: 
 - many different kind of controls
 - message logging.
--------------------------------------------------------------------------------}
module Main where

import Graphics.UI.WX
import Graphics.UI.WXCore 

main :: IO ()
main
  = start gui

gui :: IO ()
gui =
    do -- main gui elements: frame, panel, text control, and the notebook
      f    <- frameLoadRes "controls.xrc" "f" []

      -- use text control as logger
      textlog <- textCtrlRes f "textlog" []
      textCtrlMakeLogActiveTarget textlog
      logMessage "logging enabled"              

      -- button page
      ok   <- buttonRes f "ok" [on command := logMessage "ok button pressed"]
      quit <- buttonRes f "ok" [on command := close f]

      -- radio box page
      r1   <- radioBoxRes f "r1" [on select ::= logSelect]
      r2   <- radioBoxRes f "r2" [on select ::= logSelect]
      rb1  <- buttonRes f "rb1" [on command ::= onEnable r1]

      -- choice page
      c1   <- choiceRes f "c1" [on select ::= logSelect]
      c2   <- choiceRes f "c2" [on select ::= logSelect]
      cb1  <- buttonRes f "cb1" [on command ::= onEnable c1]

      -- list box page
      sl1  <- singleListBoxRes f "sl1" [on select ::= logSelect]
      sl2  <- singleListBoxRes f "sl2" [on select ::= logSelect]
      sc1  <- checkBoxRes f "sc1" [on command ::= onEnable sl1]

      -- slider/gauge page
      s    <- sliderRes f "s" []
      g    <- gaugeRes f "g" []
      set s [on command := do { i <- get s selection; set g [selection := i] } ]

      -- specify layout
      set f [ clientSize := sz 400 300 ]
      windowShow f
      return ()

  where
    -- logSelect :: (Selection w, Items w String) => w -> IO ()
    logSelect w
      = do i <- get w selection
           s <- get w (item i)
           logMessage ("selected index: " ++ show i ++ ": " ++ s)           

    onEnable w b
      = do set w [enabled :~ not]
           enable <- get w enabled
           set b [text := (if enable then "disable" else "enable")]