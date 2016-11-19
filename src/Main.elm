module Main exposing (..)

import Messages exposing (Msg)
import Models exposing (Model)
import View exposing (view)
import Update exposing (update)
import Html exposing (Html, div, text, program)


init : ( Model, Cmd Msg )
init =
    ( "Hello", Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
