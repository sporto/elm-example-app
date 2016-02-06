module View (..) where

--TODO docs

import Html exposing (div, button, text, span)
import Html.Events as Events
import Html.Attributes exposing (class)
import Dict
import Actions
import Models
import Players.List
import Players.Edit
import Perks.List
import Routing
import String


{- Main View for the application -}


view : Signal.Address Actions.Action -> Models.Model -> Html.Html
view address model =
  div
    []
    [ nav address model
    , flash address model
    , page address model
    ]


nav : Signal.Address Actions.Action -> Models.Model -> Html.Html
nav address model =
  let
    activeClass view =
      if model.routing.view == view then
        "bg-white black"
      else
        ""
  in
    div
      [ class "clearfix mb2 bg-blue white"
      ]
      [ div
          [ class "left" ]
          [ button
              [ class ("btn py2 button-narrow mr1 " ++ activeClass Routing.Players)
              , Events.onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/players")
              ]
              [ text "Players"
              ]
          , button
              [ class ("btn py2 button-narrow " ++ activeClass Routing.Perks)
              , Events.onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/perks")
              ]
              [ text "Perks"
              ]
          ]
      ]


flash : Signal.Address Actions.Action -> Models.Model -> Html.Html
flash address model =
  if String.isEmpty model.errorMessage then
    span [] []
  else
    div
      [ class "bold center p2 mb2 white bg-red rounded"
      ]
      [ text model.errorMessage ]


page : Signal.Address Actions.Action -> Models.Model -> Html.Html
page address model =
  case model.routing.view of
    Routing.Players ->
      let
        viewModel =
          { players = model.players
          , perks = model.perks
          , perksPlayers = model.perksPlayers
          }
      in
        Players.List.view (Signal.forwardTo address Actions.PlayersAction) viewModel

    Routing.EditPlayerView ->
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
                , perks = model.perks
                , perksPlayers = model.perksPlayers
                }
            in
              Players.Edit.view (Signal.forwardTo address Actions.PlayersAction) viewModel

          _ ->
            notFoundView

    -- TODO change to Routing.PerksView
    Routing.Perks ->
      let
        perksListModel =
          model.perksListModel

        updatedPerksListModel =
          { perksListModel | perks = model.perks, perksPlayers = model.perksPlayers }
      in
        Perks.List.view (Signal.forwardTo address Actions.PerksListAction) updatedPerksListModel

    _ ->
      notFoundView


notFoundView : Html.Html
notFoundView =
  div
    []
    [ text "Not found"
    ]
