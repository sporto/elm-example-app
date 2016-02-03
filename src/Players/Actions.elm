module Players.Actions (..) where

import Http
import Players.Models exposing (Id, Player)
import Hop


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List Player))
  | SaveOneDone (Result Http.Error Player)
  | HopAction Hop.Action
  | EditPlayer Int
  | ChangeLevel Id Int
