module Pages.Edit exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href, value)
import Html.Events exposing (onClick)
import Routes exposing (playersPath)
import Shared exposing (..)


view : List Player -> PlayerId -> Html.Html Msg
view players playerId =
    case findPlayer players playerId of
        Just player ->
            form player

        Nothing ->
            div [] [ text "Player not found" ]


findPlayer : List Player -> PlayerId -> Maybe Player
findPlayer players playerId =
    players
        |> List.filter (\player -> player.id == playerId)
        |> List.head


form : Player -> Html.Html Msg
form player =
    div []
        [ h1 [] [ text player.name ]
        , inputLevel player
        ]


inputLevel : Player -> Html.Html Msg
inputLevel player =
    div
        [ class "flex items-end py-2" ]
        [ label [ class "mr-3" ] [ text "Level" ]
        , div [ class "" ]
            [ span [ class "bold text-2xl" ] [ text (String.fromInt player.level) ]
            , btnLevelDecrease player
            , btnLevelIncrease player
            ]
        ]


btnLevelDecrease : Player -> Html.Html Msg
btnLevelDecrease player =
    let
        message =
            ChangeLevel player -1
    in
    button [ class "btn ml-1 h1", onClick message ]
        [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Player -> Html.Html Msg
btnLevelIncrease player =
    let
        message =
            ChangeLevel player 1
    in
    button [ class "btn ml-1 h1", onClick message ]
        [ i [ class "fa fa-plus-circle" ] [] ]


listBtn : Html Msg
listBtn =
    a
        [ class "btn regular"
        , href playersPath
        ]
        [ i [ class "fa fa-chevron-left mr-1" ] [], text "List" ]
