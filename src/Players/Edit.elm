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
    [ class "bg-silve" ]
    [ a [ class "btn button-narrow", href "#/players" ] [ text "Players" ]
    , span [] [ text " > " ]
    , span [ class "btn button-narrow" ] [ text model.player.name ]
    ]


form : Signal.Address Action -> ViewModel -> Html.Html
form address model =
  let
    player =
      model.player

    bonuses =
      999

    strength =
      model.player.level + bonuses
  in
    div
      [ class "m2" ]
      [ h1 [] [ text model.player.name ]
      , div
          [ class "clearfix py1"
          ]
          [ div [ class "col col-5" ] [ text "Level" ]
          , div
              [ class "col col-7" ]
              [ span [ class "h2 bold" ] [ text (toString player.level) ]
              , a
                  [ class "btn ml1 h1" ]
                  [ i [ class "fa fa-minus-circle" ] [] ]
              , a
                  [ class "btn ml1 h1" ]
                  [ i [ class "fa fa-plus-circle" ] [] ]
              ]
          ]
      , div
          [ class "clearfix py1" ]
          [ div [ class "col col-5" ] [ text "Bonuses" ]
          , div [ class "col col-7 h2" ] [ text (toString bonuses) ]
          ]
      , div
          [ class "clearfix py1" ]
          [ div [ class "col col-5" ] [ text "Strength" ]
          , div [ class "col col-7 h2 bold" ] [ text (toString strength) ]
          ]
      , div
          [ class "clearfix py1"
          ]
          [ div [ class "col col-5" ] [ text "Name" ]
          , div
              [ class "col col-7" ]
              [ input
                  [ class "field-light"
                  , value player.name
                  ]
                  []
              ]
          ]
      , div
          [ class "clearfix py1"
          ]
          [ div [ class "col col-5" ] [ text "Perks" ]
          , div
              [ class "col col-7" ]
              []
          ]
      ]
