module Players.List (..) where

import Html as H
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Players.Models exposing (Player)
import Players.Actions as PlayersActions
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)


type alias ViewModel =
  { players : List Player
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> H.Html
view address model =
  H.div
    []
    [ H.div
        [ class "right-align" ]
        [ H.button [ class "btn", onClick address (PlayersActions.CreatePlayer) ] [ H.text "Add player" ]
        ]
    , H.table
        [ class "table-light" ]
        [ H.thead
            []
            [ H.tr
                []
                [ H.th [] [ H.text "Id" ]
                , H.th [] [ H.text "Name" ]
                , H.th [] [ H.text "Level" ]
                , H.th [] [ H.text "Bonus" ]
                , H.th [] [ H.text "Strengh" ]
                , H.th [] [ H.text "Actions" ]
                ]
            ]
        , H.tbody [] (List.map (playerRow address model) model.players)
        ]
    ]


playerRow : Signal.Address PlayersActions.Action -> ViewModel -> Player -> H.Html
playerRow address model player =
  let
    bonuses =
      bonusesForPlayer model player

    strength =
      bonuses + player.level
  in
    H.tr
      []
      [ H.td [] [ H.text (toString player.id) ]
      , H.td [] [ H.text player.name ]
      , H.td [] [ H.text (toString player.level) ]
      , H.td [] [ H.text (toString bonuses) ]
      , H.td [] [ H.text (toString strength) ]
      , H.td
          []
          [ H.button
              [ class "btn btn-outline mr1"
              , onClick address (PlayersActions.AskForDeletePlayerConfirmation player)
              ]
              [ H.text "Delete" ]
          , H.button
              [ class "btn btn-outline"
              , onClick address (PlayersActions.EditPlayer player.id)
              ]
              [ H.text "Edit" ]
          ]
      ]


bonusesForPlayer : ViewModel -> Player -> Int
bonusesForPlayer model player =
  perksForPlayer model player
    |> List.foldl (\perk acc -> acc + perk.bonus) 0


perksForPlayer : ViewModel -> Player -> List Perk
perksForPlayer model player =
  let
    perkIds =
      model.perksPlayers
        |> List.filter (\perkPlayer -> perkPlayer.perkId == player.id)
        |> List.map (\perkPlayer -> perkPlayer.perkId)
  in
    model.perks
      |> List.filter (\perk -> List.any (\id -> id == perk.id) perkIds)
