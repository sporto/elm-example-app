module View (..) where

import Html exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Players.List


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    []
    [ page address model ]


page : Signal.Address Action -> AppModel -> Html.Html
page address model =
  let
    viewModel =
      { players = model.players
      }
  in
    Players.List.view (Signal.forwardTo address PlayersAction) viewModel
