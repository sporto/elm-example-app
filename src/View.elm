module View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Routing
import Players.List
import Players.Edit
import String
import Players.Models exposing (PlayerId)


view : Signal.Address Action -> AppModel -> Html
view address model =
  let
    _ =
      Debug.log "model" model
  in
    div
      []
      [ flash address model
      , page address model
      ]


page : Signal.Address Action -> AppModel -> Html.Html
page address model =
  case model.routing.route of
    Routing.PlayersRoute ->
      playersPage address model

    Routing.PlayerEditRoute playerId ->
      playerEditPage address model playerId

    Routing.NotFoundRoute ->
      notFoundView


playersPage : Signal.Address Action -> AppModel -> Html.Html
playersPage address model =
  let
    viewModel =
      { players = model.players
      }
  in
    Players.List.view (Signal.forwardTo address PlayersAction) viewModel


playerEditPage : Signal.Address Action -> AppModel -> PlayerId -> Html.Html
playerEditPage address model playerId =
  let
    maybePlayer =
      model.players
        |> List.filter (\player -> player.id == playerId)
        |> List.head
  in
    case maybePlayer of
      Just player ->
        let
          viewModel =
            { player = player
            }
        in
          Players.Edit.view (Signal.forwardTo address PlayersAction) viewModel

      Nothing ->
        notFoundView


notFoundView : Html.Html
notFoundView =
  div
    []
    [ text "Not found"
    ]


flash : Signal.Address Action -> AppModel -> Html
flash address model =
  if String.isEmpty model.errorMessage then
    span [] []
  else
    div
      [ class "bold center p2 mb2 white bg-red rounded"
      ]
      [ text model.errorMessage ]
