module Players.List where

import Html as H
import Players.Models as Models
import Players.Actions as Actions

view : Signal.Address Actions.Action -> List Models.Player -> H.Html
view address collection =
  H.table [] [
    H.tbody [] (List.map (playerRow address) collection)
  ]

playerRow : Signal.Address Actions.Action -> Models.Player -> H.Html
playerRow address player =
  H.tr [] [
    H.td [] [ H.text (toString player.id) ],
    H.td [] [ H.text player.name ]
  ]
