module View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Actions exposing (..)
import Models exposing (..)
import Routing
import Players.List
import Players.Edit
import Perks.List
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
      [ nav address model
      , flash address model
      , page address model
      ]


nav : Signal.Address Action -> AppModel -> Html.Html
nav address model =
  let
    activeClass route =
      if model.routing.route == route then
        "bg-white black"
      else
        ""
  in
    div
      [ class "clearfix bg-blue white"
      ]
      [ div
          [ class "left" ]
          [ button
              [ class ("btn py2 button-narrow mr1 " ++ activeClass Routing.PlayersRoute)
              , onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/players")
              ]
              [ i [ class "fa fa-users mr1" ] []
              , text "Players"
              ]
          , button
              [ class ("btn py2 button-narrow " ++ activeClass Routing.PerksRoute)
              , onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/perks")
              ]
              [ i [ class "fa fa-bookmark mr1" ] []
              , text "Perks"
              ]
          ]
      ]


page : Signal.Address Action -> AppModel -> Html.Html
page address model =
  case model.routing.route of
    Routing.PlayersRoute ->
      playersPage address model

    Routing.PlayerEditRoute playerId ->
      playerEditPage address model playerId

    Routing.PerksRoute ->
      perksPage address model

    Routing.NotFoundRoute ->
      notFoundView


playersPage : Signal.Address Action -> AppModel -> Html.Html
playersPage address model =
  let
    viewModel =
      { players = model.players
      , perks = model.perks
      , perksPlayers = model.perksPlayers
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
            , perks = model.perks
            , perksPlayers = model.perksPlayers
            }
        in
          Players.Edit.view (Signal.forwardTo address PlayersAction) viewModel

      Nothing ->
        notFoundView


perksPage : Signal.Address Action -> AppModel -> Html.Html
perksPage address model =
  let
    perksListModel =
      model.perksListModel

    updatedPerksListModel =
      { perksListModel | perks = model.perks, perksPlayers = model.perksPlayers }
  in
    Perks.List.view (Signal.forwardTo address PerksListAction) updatedPerksListModel


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
