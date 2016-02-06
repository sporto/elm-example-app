module Players.Actions (..) where

import Http
import Perks.Models exposing (PerkId)
import Players.Models exposing (PlayerId, Player)
import Hop


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List Player))
  | SaveOneDone (Result Http.Error Player)
  | HopAction Hop.Action
  | EditPlayer Int
  | ChangeLevel PlayerId Int
  | ChangeName PlayerId String
  | CreatePlayer
  | CreatePlayerDone (Result Http.Error Player)
  | AskForDeletePlayerConfirmation Player
  | GetDeleteConfirmation PlayerId
  | DeletePlayerDone (Result Http.Error Player)
  | TogglePlayerPerk PlayerId PerkId Bool
