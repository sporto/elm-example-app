module Players.List (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Players.Actions exposing (..)
import Players.Models exposing (Player)


type alias ViewModel =
  { players : List Player
  }


view : Signal.Address Action -> ViewModel -> Html.Html
view address model =
  div
    []
    [ nav address model
    , list address model
    ]


nav : Signal.Address Action -> ViewModel -> Html.Html
nav address model =
  div
    [ class "clearfix mb2 white bg-black" ]
    [ div [ class "left p2" ] [ text "Players" ]
    , div [ class "right p1" ] [ addBtn address model ]
    ]


list : Signal.Address Action -> ViewModel -> Html.Html
list address model =
  div
    []
    [ table
        [ class "table-light" ]
        [ thead
            []
            [ tr
                []
                [ th [] [ text "Id" ]
                , th [] [ text "Name" ]
                , th [] [ text "Level" ]
                , th [] [ text "Actions" ]
                ]
            ]
        , tbody [] (List.map (playerRow address model) model.players)
        ]
    ]


playerRow : Signal.Address Action -> ViewModel -> Player -> Html.Html
playerRow address model player =
  tr
    []
    [ td [] [ text (toString player.id) ]
    , td [] [ text player.name ]
    , td [] [ text (toString player.level) ]
    , td
        []
        [ editBtn address player ]
    ]


editBtn : Signal.Address Action -> Player -> Html.Html
editBtn address player =
  button
    [ class "btn regular"
    , onClick address (EditPlayer player.id)
    ]
    [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]


addBtn : Signal.Address Action -> ViewModel -> Html.Html
addBtn address model =
  button
    [ class "btn", onClick address CreatePlayer ]
    [ i [ class "fa fa-user-plus mr1" ] []
    , text "Add player"
    ]
