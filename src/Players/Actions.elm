module Players.Actions (..) where

import Hop
import Players.Models exposing (PlayerId, Player)


type Action
  = NoOp
  | EditPlayer PlayerId
  | HopAction Hop.Action
