module PerksPlayers.Actions (..) where

import Http
import Models exposing (PlayerPerkToggle)
import PerksPlayers.Models exposing (PerkPlayer)


type alias PlayerId =
  Int


type alias PerkId =
  Int


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List PerkPlayer))
  | TogglePlayerPerk PlayerPerkToggle
  | CreatePerkPlayerDone (Result Http.Error PerkPlayer)
  | DeletePerkPlayerDone Int (Result Http.RawError Http.Response)
