module Main exposing (..)

import Commands exposing (fetchPlayers)
import Messages exposing (..)
import Models exposing (Model, initialModel)
import Navigation exposing (Location)
import Routing
import Update exposing (update)
import View exposing (view)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, fetchPlayers )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
