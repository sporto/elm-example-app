module PerksPlayers.Actions (..) where

import Http
import PerksPlayers.Models exposing (PerkPlayer)


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List PerkPlayer))
  | TaskDone ()
