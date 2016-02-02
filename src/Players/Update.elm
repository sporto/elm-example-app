module Players.Update (..) where

import Effects exposing (Effects)
import Players.Actions exposing (..)
import Players.Models exposing (Player)
import CommonEffects
import Actions as MainActions


update : Action -> List Player -> ( List Player, Effects Action, Effects MainActions.Action )
update action collection =
  case action of
    FetchAllDone result ->
      case result of
        Ok players ->
          ( players, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( [], Effects.none, CommonEffects.showError message )

    _ ->
      ( collection, Effects.none, Effects.none )
