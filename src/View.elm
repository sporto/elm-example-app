module View (..) where

import Html as H
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


view : Signal.Address Actions.Action -> Models.Model -> H.Html
view address model =
  H.div
    []
    [ nav address model
    , flash address model
    , page address model
    ]


nav : Signal.Address Actions.Action -> Models.Model -> H.Html
nav address model =
  let
    activeClass view =
      if model.routing.view == view then
        "bg-white black"
      else
        ""
  in
    H.div
      [ class "clearfix mb2 bg-blue white"
      ]
      [ H.div
          [ class "left" ]
          [ H.button
              [ class ("btn py2 button-narrow mr1 " ++ activeClass Routing.Players)
              , Events.onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/players")
              ]
              [ H.text "Players"
              ]
          , H.button
              [ class ("btn py2 button-narrow " ++ activeClass Routing.Perks)
              , Events.onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/perks")
              ]
              [ H.text "Perks"
              ]
          ]
      ]


flash : Signal.Address Actions.Action -> Models.Model -> H.Html
flash address model =
  if String.isEmpty model.errorMessage then
    H.span [] []
  else
    H.div [ class "bold center p2 mb2 white bg-red rounded" ] [ H.text model.errorMessage ]


page : Signal.Address Actions.Action -> Models.Model -> H.Html
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
            Players.Edit.view (Signal.forwardTo address Actions.PlayersAction) { player = player }

          _ ->
            notFoundView

    -- TODO change to PerksView
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


notFoundView =
  H.div
    []
    [ H.text "Not found"
    ]
