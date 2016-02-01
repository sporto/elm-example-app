module Players.Update (..) where

import Effects exposing (Effects)
import Players.Actions exposing (..)
import Players.Models exposing (Player)


update : Action -> List Player -> ( List Player, Effects Action )
update action collection =
  case action of
    FetchAllDone result ->
      case result of
        Ok players ->
          ( players, Effects.none )

        Err error ->
          ( [], Effects.none )

    _ ->
      ( collection, Effects.none )
