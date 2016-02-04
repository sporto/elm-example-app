module Players.Edit.Perks (..) where

import Html as H
import Html.Attributes exposing (class)
import Players.Models exposing (Id)
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)
import Players.Actions as PlayersActions


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
  H.tr
    []
    [ H.td [] []
    , H.td [] [ H.text perk.name ]
    ]
