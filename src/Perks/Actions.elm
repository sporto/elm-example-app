module Perks.Actions (..) where

import Http
import Perks.Models exposing (Perk)


type Action
  = NoOp
  | FetchAll
  | FetchAllDone (Result Http.Error (List Perk))
  | TaskDone ()
