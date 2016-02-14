module Players.Actions (..) where

import Http
import Hop
import Players.Models exposing (PlayerId, Player)


type Action
  = NoOp
  | HopAction Hop.Action
  | EditPlayer PlayerId
  | ListPlayers
  | FetchAllDone (Result Http.Error (List Player))
  | TaskDone ()
