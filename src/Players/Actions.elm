module Players.Actions (..) where

import Players.Models exposing (PlayerId)
import Hop


type Action
  = NoOp
  | HopAction ()
  | EditPlayer PlayerId
  | ListPlayers
