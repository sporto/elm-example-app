module Players.Actions (..) where

import Players.Models exposing (PlayerId)
import Hop


type Action
  = NoOp
  | HopAction Hop.Action
  | EditPlayer PlayerId
  | ListPlayers
