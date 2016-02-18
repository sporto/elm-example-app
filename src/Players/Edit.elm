module Players.Edit (..) where

import Html exposing (..)
import Html.Attributes exposing (class, value, href)
import Players.Models exposing (..)
import Players.Actions exposing (..)


type alias ViewModel =
  { player : Player
  }


view : Signal.Address Action -> ViewModel -> Html.Html
view address model =
  div
    []
    [ nav address model
    , form address model
    ]


nav : Signal.Address Action -> ViewModel -> Html.Html
nav address model =
  div
    [ class "clearfix mb2 white bg-black p1" ]
    []


form : Signal.Address Action -> ViewModel -> Html.Html
form address model =
  div
    [ class "m3" ]
    [ h1 [] [ text model.player.name ]
    , formLevel address model
    , formName address model
    ]


formLevel : Signal.Address Action -> ViewModel -> Html.Html
formLevel address model =
  div
    [ class "clearfix py1"
    ]
    [ div [ class "col col-5" ] [ text "Level" ]
    , div
        [ class "col col-7" ]
        [ span [ class "h2 bold" ] [ text (toString model.player.level) ]
        , btnLevelDecrease address model
        , btnLevelIncrease address model
        ]
    ]


btnLevelDecrease : Signal.Address Action -> ViewModel -> Html.Html
btnLevelDecrease address model =
  a
    [ class "btn ml1 h1" ]
    [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Signal.Address Action -> ViewModel -> Html.Html
btnLevelIncrease address model =
  a
    [ class "btn ml1 h1" ]
    [ i [ class "fa fa-plus-circle" ] [] ]


formName : Signal.Address Action -> ViewModel -> Html.Html
formName address model =
  div
    [ class "clearfix py1"
    ]
    [ div [ class "col col-5" ] [ text "Name" ]
    , div
        [ class "col col-7" ]
        [ inputName address model
        ]
    ]


inputName : Signal.Address Action -> ViewModel -> Html.Html
inputName address model =
  input
    [ class "field-light"
    , value model.player.name
    ]
    []
