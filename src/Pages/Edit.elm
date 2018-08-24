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
    div [ class "m-3" ]
        [ h1 [] [ text player.name ]
        , formLevel player
        ]


formLevel : Player -> Html.Html Msg
formLevel player =
    div
        [ class "py-1"
        ]
        [ div [ class "col col-5" ] [ text "Level" ]
        , div [ class "col col-7" ]
            [ span [ class "h2 bold" ] [ text (String.fromInt player.level) ]
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
    a [ class "btn ml-1 h1", onClick message ]
        [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Player -> Html.Html Msg
btnLevelIncrease player =
    let
        message =
            ChangeLevel player 1
    in
    a [ class "btn ml-1 h1", onClick message ]
        [ i [ class "fa fa-plus-circle" ] [] ]


listBtn : Html Msg
listBtn =
    a
        [ class "btn regular"
        , href playersPath
        ]
        [ i [ class "fa fa-chevron-left mr-1" ] [], text "List" ]
