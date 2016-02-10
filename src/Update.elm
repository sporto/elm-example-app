module Update (..) where

import Effects exposing (Effects)
import Models exposing (..)
import Actions exposing (..)
import Players.Update


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case action of
    PlayersAction subAction ->
      let
        updateModel =
          { players = model.players
          }

        ( updatedPlayers, fx ) =
          Players.Update.update subAction updateModel
      in
        ( { model | players = updatedPlayers }, Effects.map PlayersAction fx )

    NoOp ->
      ( model, Effects.none )
