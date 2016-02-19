module PerksPlayers.Actions (..) where

import Http
import Models exposing (PlayerPerkToggle)
import PerksPlayers.Models exposing (PerkPlayer)
import Players.Models exposing (PlayerId)


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List PerkPlayer))
  | TogglePlayerPerk PlayerPerkToggle
  | CreatePerkPlayerDone (Result Http.Error PerkPlayer)
  | DeletePerkPlayerDone PlayerId (Result Http.RawError Http.Response)
  | TaskDone ()
