module Perks.Update (..) where

import Effects exposing (Effects)
import Perks.Actions exposing (..)
import Perks.Models exposing (Perk)


type alias UpdateModel =
  { perks : List Perk
  , showErrorAddress : Signal.Address String
  }


update : Action -> UpdateModel -> ( List Perk, Effects Action )
update action model =
  case action of
    FetchAllDone result ->
      case result of
        Ok perks ->
          ( perks, Effects.none )

        Err error ->
          let
            message =
              toString error

            fx =
              Signal.send model.showErrorAddress message
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( [], fx )

    _ ->
      ( model.perks, Effects.none )
