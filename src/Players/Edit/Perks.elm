module Players.Edit.Perks (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', checked)
import Html.Events exposing (on, targetChecked)
import Players.Models exposing (PlayerId)
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)
import PerksPlayers.Actions
import PerksPlayers.Utils
import Players.Actions as PlayersActions
import Players.Utils as Utils


type alias ViewModel =
  { playerId : PlayerId
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> Html.Html
view address model =
  let
    playerId =
      model.playerId
  in
    div
      []
      [ table
          [ class "table-light" ]
          [ thead
              []
              [ tr
                  []
                  [ th [] []
                  , th [] [ text "Perk" ]
                  , th [] [ text "Bonus" ]
                  ]
              ]
          , tbody
              []
              (perkRows address model)
          ]
      ]


perkRows : Signal.Address PlayersActions.Action -> ViewModel -> List Html.Html
perkRows address model =
  List.map (perkRow address model) model.perks


perkRow : Signal.Address PlayersActions.Action -> ViewModel -> Perk -> Html.Html
perkRow address model perk =
  let
    playerId =
      model.playerId

    perkId =
      perk.id

    hasPerk =
      PerksPlayers.Utils.doesPlayerIdHasPerkId playerId perkId model.perksPlayers
  in
    tr
      []
      [ td
          []
          [ input
              [ type' "checkbox"
              , checked hasPerk
              , on "change" targetChecked (Signal.message address << (PlayersActions.TogglePlayerPerk playerId perkId))
              , class ""
              ]
              []
          ]
      , td [] [ text perk.name ]
      , td [] [ text (toString perk.bonus) ]
      ]
