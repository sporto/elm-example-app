module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation exposing (Key)
import Commands exposing (fetchPlayers)
import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Routing
import Update exposing (update)
import Url exposing (Url)
import View exposing (view)


type alias Flags =
    {}


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        currentRoute =
            Routing.parseUrl url
    in
    ( initialModel currentRoute key, fetchPlayers )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application 
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = Msgs.OnUrlRequest
        , onUrlChange = Msgs.OnUrlChange
        }
