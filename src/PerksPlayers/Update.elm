module PerksPlayers.Update (..) where

import Effects exposing (Effects)
import PerksPlayers.Actions exposing (..)
import PerksPlayers.Models exposing (PerkPlayer)
import CommonEffects
import Actions as MainActions


update : Action -> List PerkPlayer -> ( List PerkPlayer, Effects Action, Effects MainActions.Action )
update action collection =
  case action of
    FetchAllDone result ->
      case result of
        Ok perksPlayers ->
          ( perksPlayers, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( [], Effects.none, CommonEffects.showError message )

    _ ->
      ( collection, Effects.none, Effects.none )
