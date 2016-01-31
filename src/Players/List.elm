module Players.List where

import Html as H
import Html.Attributes exposing (class)
import Players.Models as Models
import Players.Actions as Actions

view : Signal.Address Actions.Action -> List Models.Player -> H.Html
view address collection =
  H.table [ class "table-light" ] [
    H.thead [] [
      H.tr [] [
        H.th [] [ H.text "Id" ],
        H.th [] [ H.text "Name" ],
        H.th [] [ H.text "Level" ],
        H.th [] [ H.text "Bonus" ],
        H.th [] [ H.text "Strengh" ],
        H.th [] [ H.text "Actions" ]
      ]
    ],
    H.tbody [] (List.map (playerRow address) collection)
  ]

playerRow : Signal.Address Actions.Action -> Models.Player -> H.Html
playerRow address player =
  H.tr [] [
    H.td [] [ H.text (toString player.id) ],
    H.td [] [ H.text player.name ],
    H.td [] [ H.text (toString player.level) ],
    H.td [] [ H.text (toString player.level) ],
    H.td [] [ H.text (toString player.level) ],
    H.td [] [ 
      H.button [ class "btn" ] [ H.text "Delete" ],
      H.button [ class "btn" ] [ H.text "Edit" ]
    ]
  ]
