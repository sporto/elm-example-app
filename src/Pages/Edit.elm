module Pages.Edit exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, href, value)
import Html.Events exposing (onClick)
import Http
import Player exposing (Player)
import Routes exposing (playersPath)
import Shared exposing (..)


type alias Model =
    { player : RemoteData Player
    }


type Msg
    = OnFetchPlayer (Result Http.Error Player)
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)


init : Flags -> String -> ( Model, Cmd Msg )
init flags playerId =
    ( { player = Loading }, fetchPlayer flags playerId )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Flags -> Msg -> Model -> ( Model, Cmd Msg )
update flags msg model =
    case msg of
        OnFetchPlayer (Ok player) ->
            ( { model | player = Loaded player }, Cmd.none )

        OnFetchPlayer (Err err) ->
            ( { model | player = Failure }, Cmd.none )

        ChangeLevel player howMuch ->
            let
                updatedPlayer =
                    { player | level = player.level + howMuch }
            in
            ( model, savePlayer flags updatedPlayer )

        OnPlayerSave (Ok player) ->
            ( { model | player = Loaded player }, Cmd.none )

        OnPlayerSave (Err error) ->
            ( model, Cmd.none )



-- DATA


fetchPlayer : Flags -> String -> Cmd Msg
fetchPlayer flags playerId =
    Http.get (flags.api ++ "/players/" ++ playerId) Player.decoder
        |> Http.send OnFetchPlayer


savePlayer : Flags -> Player -> Cmd Msg
savePlayer flags player =
    savePlayerRequest flags player
        |> Http.send OnPlayerSave


savePlayerRequest : Flags -> Player -> Http.Request Player
savePlayerRequest flags player =
    Http.request
        { body = Player.encode player |> Http.jsonBody
        , expect = Http.expectJson Player.decoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , url = savePlayerUrl flags player.id
        , withCredentials = False
        }


savePlayerUrl : Flags -> String -> String
savePlayerUrl flags playerId =
    flags.api ++ "/players/" ++ playerId



-- VIEWS


view : Model -> Html Msg
view model =
    let
        content =
            case model.player of
                NotAsked ->
                    text ""

                Loading ->
                    text "Loading ..."

                Loaded player ->
                    viewWithData player

                Failure ->
                    text "Error"
    in
    section [ class "p-4" ]
        [ content ]


viewWithData : Player -> Html.Html Msg
viewWithData player =
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
