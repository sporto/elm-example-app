module Perks.List where

import Html as H
import Html.Attributes exposing (class)
import Perks.Models as Models
import Perks.Actions as Actions
import PerksPlayers.Models

view : Signal.Address Actions.Action -> (List Models.Perk, List PerksPlayers.Models.PerkPlayer) -> H.Html
view address (perks, perksPlayers) =
  H.table [ class "table-light" ] [
    H.thead [] [
      H.tr [] [
        H.th [] [ H.text "Id" ],
        H.th [] [ H.text "Name" ],
        H.th [] [ H.text "Bonus" ],
        H.th [] [ H.text "Player count" ],
        H.th [] [ H.text "Actions" ]
      ]
    ],
    H.tbody [] (List.map (perkRow address perksPlayers) perks)
  ]

perkRow : Signal.Address Actions.Action -> List PerksPlayers.Models.PerkPlayer -> Models.Perk -> H.Html
perkRow address perksPlayers perk =
  H.tr [] [
    H.td [] [ H.text (toString perk.id) ],
    H.td [] [ H.text perk.name ],
    H.td [] [ H.text (toString perk.bonus) ],
    H.td [] [ H.text (toString (userCountForPerk perksPlayers perk)) ],
    H.td [] [ 
      H.button [ class "btn" ] [ H.text "Expand" ]
    ]
  ]

userCountForPerk : List PerksPlayers.Models.PerkPlayer -> Models.Perk -> Int
userCountForPerk perksPlayers perk =
  perksPlayers
    |> List.filter (\perkPlayer -> perkPlayer.perkId == perk.id)
    |> List.length
