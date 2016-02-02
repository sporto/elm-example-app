module Players.Edit (..) where

import Html as H
import Html.Attributes exposing (class)
import Players.Models exposing (Player)
import Players.Actions as PlayersActions


type alias ViewModel =
  { player : Player
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> H.Html
view address model =
  H.div
    [ class "m2" ]
    [ H.h1 [] [ H.text model.player.name ]
    , H.div
        [ class "clearfix py1"
        ]
        [ H.div [ class "col col-5" ] [ H.text "Level" ]
        , H.div
            [ class "col col-7" ]
            [ H.span [ class "h2 bold" ] [ H.text (toString model.player.level) ]
            , H.a [ class "btn btn-outline ml1" ] [ H.text "-" ]
            , H.a [ class "btn btn-outline ml1" ] [ H.text "+" ]
            ]
        ]
    , H.div
        [ class "clearfix py1" ]
        [ H.div [ class "col col-5" ] [ H.text "Bonuses" ]
        , H.div [ class "col col-7 h2" ] [ H.text "99" ]
        ]
    , H.div
        [ class "clearfix py1" ]
        [ H.div [ class "col col-5" ] [ H.text "Strength" ]
        , H.div [ class "col col-7 h2 bold" ] [ H.text "99" ]
        ]
    , H.div
        [ class "clearfix py1"
        ]
        [ H.div [ class "col col-5" ] [ H.text "Name" ]
        , H.div
            [ class "col col-7" ]
            [ H.input [ class "field-light" ] []
            ]
        ]
    , H.div
        [ class "clearfix py1"
        ]
        [ H.div [ class "col col-5" ] [ H.text "Perks" ]
        , H.div [ class "col col-7" ] []
        ]
    ]
