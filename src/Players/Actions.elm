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
  | ChangeName Id String
  | CreatePlayer
  | CreatePlayerDone (Result Http.Error Player)
  | AskToDeletePlayer Player
  | DeletePlayer Id
  | DeletePlayerDone (Result Http.Error Player)
