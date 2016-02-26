module Players.Actions (..) where

import Http
import Players.Models exposing (PlayerId, Player)
import Hop


type Action
  = NoOp
  | HopAction Hop.Action
  | EditPlayer PlayerId
  | ListPlayers
  | FetchAllDone (Result Http.Error (List Player))
  | TaskDone ()
