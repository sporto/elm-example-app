module PerksPlayers.Update (..) where

import Effects exposing (Effects)
import PerksPlayers.Actions exposing (..)
import PerksPlayers.Models exposing (PerkPlayerId, PerkPlayer)


type alias UpdateModel =
  { perksPlayers : List PerkPlayer
  , showErrorAddress : Signal.Address String
  }


update : Action -> UpdateModel -> ( List PerkPlayer, Effects Action )
update action model =
  case action of
    FetchAllDone result ->
      case result of
        Ok perksPlayers ->
          ( perksPlayers, Effects.none )

        Err error ->
          let
            message =
              toString error

            fx =
              Signal.send model.showErrorAddress message
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( model.perksPlayers, fx )

    _ ->
      ( model.perksPlayers, Effects.none )
