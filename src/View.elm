module View (..) where

import Html exposing (..)
import Dict
import Actions exposing (..)
import Models exposing (..)
import Routing
import Players.List
import Players.Edit


view : Signal.Address Action -> AppModel -> Html
view address model =
  let
    _ =
      Debug.log "model" model
  in
    div
      []
      [ page address model ]


page : Signal.Address Action -> AppModel -> Html.Html
page address model =
  case model.routing.view of
    Routing.PlayersView ->
      playersPage address model

    Routing.PlayerEditView ->
      playerEditPage address model

    Routing.NotFoundView ->
      notFoundView


playersPage : Signal.Address Action -> AppModel -> Html.Html
playersPage address model =
  let
    viewModel =
      { players = model.players
      }
  in
    Players.List.view (Signal.forwardTo address PlayersAction) viewModel


playerEditPage : Signal.Address Action -> AppModel -> Html.Html
playerEditPage address model =
  let
    playerId =
      model.routing.routerPayload.params
        |> Dict.get "id"
        |> Maybe.withDefault ""

    maybePlayer =
      model.players
        |> List.filter (\player -> (toString player.id) == playerId)
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
