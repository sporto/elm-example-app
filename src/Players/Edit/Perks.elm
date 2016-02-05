module Players.Edit.Perks (..) where

import Html as H
import Html.Attributes exposing (class, type', checked)
import Html.Events exposing (on, targetChecked)
import Players.Models exposing (Id)
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)
import PerksPlayers.Actions
import Players.Actions as PlayersActions
import Players.Utils as Utils


type alias ViewModel =
  { playerId : Id
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> H.Html
view address model =
  let
    playerId =
      model.playerId
  in
    H.div
      []
      [ H.table
          [ class "table-light" ]
          [ H.thead
              []
              [ H.tr
                  []
                  [ H.th [] []
                  , H.th [] [ H.text "Perk" ]
                  , H.th [] [ H.text "Bonus" ]
                  ]
              ]
          , H.tbody
              []
              (perkRows address model)
          ]
      ]


perkRows : Signal.Address PlayersActions.Action -> ViewModel -> List H.Html
perkRows address model =
  List.map (perkRow address model) model.perks


perkRow : Signal.Address PlayersActions.Action -> ViewModel -> Perk -> H.Html
perkRow address model perk =
  let
    playerId =
      model.playerId

    perkId =
      perk.id

    hasPerk =
      Utils.isPerkIdOnPlayerId model.perksPlayers perkId playerId
  in
    H.tr
      []
      [ H.td
          []
          [ H.input
              [ type' "checkbox"
              , checked hasPerk
              , on "change" targetChecked (Signal.message address << (PlayersActions.TogglePlayerPerk playerId perkId))
              , class ""
              ]
              []
          ]
      , H.td [] [ H.text perk.name ]
      , H.td [] [ H.text (toString perk.bonus) ]
      ]
