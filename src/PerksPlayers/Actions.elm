module PerksPlayers.Actions (..) where

import Http
import PerksPlayers.Models exposing (PerkPlayer)


type alias PlayerId =
  Int


type alias PerkId =
  Int


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List PerkPlayer))
  | TogglePlayerPerk PlayerId PerkId Bool
  | CreatePerkPlayerDone (Result Http.Error PerkPlayer)
  | DeletePerkPlayerDone (Result Http.Error PerkPlayer)
