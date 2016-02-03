module Players.Actions (..) where

import Http
import Players.Models exposing (Player)
import Hop


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List Player))
  | HopAction Hop.Action
  | EditPlayer Int
  | IncreaseLevel Int
  | DecreaseLevel Int
