module Players.Update (..) where

import Effects exposing (Effects)
import Players.Actions exposing (..)
import Players.Models exposing (..)


type alias UpdateModel =
  { players : List Player
  }


update : Action -> UpdateModel -> ( List Player, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model.players, Effects.none )
