module Pages.List exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Routes
import Shared exposing (..)


view : List Player -> Html Msg
view players =
    table []
        [ thead []
            [ tr []
                [ th [ class "p-2" ] [ text "Id" ]
                , th [ class "p-2" ] [ text "Name" ]
                , th [ class "p-2" ] [ text "Level" ]
                , th [ class "p-2" ] [ text "Actions" ]
                ]
            ]
        , tbody [] (List.map playerRow players)
        ]


playerRow : Player -> Html Msg
playerRow player =
    tr []
        [ td [ class "p-2" ] [ text player.id ]
        , td [ class "p-2" ] [ text player.name ]
        , td [ class "p-2" ] [ text (String.fromInt player.level) ]
        , td [ class "p-2" ]
            [ editBtn player ]
        ]


editBtn : Player -> Html.Html Msg
editBtn player =
    let
        path =
            Routes.playerPath player.id
    in
    a
        [ class "btn regular"
        , href path
        ]
        [ i [ class "fa fa-edit mr-1" ] [], text "Edit" ]
