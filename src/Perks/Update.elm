module Perks.Update (..) where

import Effects exposing (Effects)
import Perks.Actions exposing (..)
import Perks.Models exposing (Perk)
import CommonEffects
import Actions as MainActions


update : Action -> List Perk -> ( List Perk, Effects Action, Effects MainActions.Action )
update action collection =
  case action of
    FetchAllDone result ->
      case result of
        Ok perks ->
          ( perks, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( [], Effects.none, CommonEffects.showError message )

    _ ->
      ( collection, Effects.none, Effects.none )
