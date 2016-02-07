module Players.List (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Players.Models exposing (Player)
import Players.Actions as PlayersActions
import Players.Utils
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)


type alias ViewModel =
  { players : List Player
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> Html.Html
view address model =
  div
    []
    [ div
        [ class "right-align" ]
        [ button [ class "btn", onClick address (PlayersActions.CreatePlayer) ] [ text "Add player" ]
        ]
    , table
        [ class "table-light" ]
        [ thead
            []
            [ tr
                []
                [ th [] [ text "Id" ]
                , th [] [ text "Name" ]
                , th [] [ text "Level" ]
                , th [] [ text "Bonus" ]
                , th [] [ text "Strengh" ]
                , th [] [ text "Actions" ]
                ]
            ]
        , tbody [] (List.map (playerRow address model) model.players)
        ]
    ]


playerRow : Signal.Address PlayersActions.Action -> ViewModel -> Player -> Html.Html
playerRow address model player =
  let
    bonuses =
      Players.Utils.bonusesForPlayerId model.perksPlayers model.perks player.id

    strength =
      bonuses + player.level
  in
    tr
      []
      [ td [] [ text (toString player.id) ]
      , td [] [ text player.name ]
      , td [] [ text (toString player.level) ]
      , td [] [ text (toString bonuses) ]
      , td [] [ text (toString strength) ]
      , td
          []
          [ button
              [ class "btn btn-outline mr1"
              , onClick address (PlayersActions.AskForDeletePlayerConfirmation player)
              ]
              [ i [ class "fa fa-trash" ] [], text "Delete" ]
          , button
              [ class "btn btn-outline"
              , onClick address (PlayersActions.EditPlayer player.id)
              ]
              [ text "Edit" ]
          ]
      ]
