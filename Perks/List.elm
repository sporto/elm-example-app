module Perks.List where

import Html as H
import Perks.Models as Models
import Perks.Actions as Actions

view : Signal.Address Actions.Action -> List Models.Perk -> H.Html
view address collection =
  H.table [] [
    H.thead [] [
      H.tr [] [
        H.th [] [ H.text "Id" ],
        H.th [] [ H.text "Name" ],
        H.th [] [ H.text "Bonus" ],
        H.th [] [ H.text "Player count" ],
        H.th [] [ H.text "Actions" ]
      ]
    ],
    H.tbody [] (List.map (perkRow address) collection)
  ]

perkRow : Signal.Address Actions.Action -> Models.Perk -> H.Html
perkRow address perk =
  H.tr [] [
    H.td [] [ H.text (toString perk.id) ],
    H.td [] [ H.text perk.name ],
    H.td [] [ H.text (toString perk.bonus) ],
    H.td [] [ ],
    H.td [] [ 
      H.button [] [ H.text "Expand" ]
    ]
  ]
