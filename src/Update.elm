module Update exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg)
import Navigation
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Msgs.ShowPlayers ->
            ( model, Navigation.newUrl "#players" )

        Msgs.ShowPlayer id ->
            ( model, Navigation.newUrl ("#players/" ++ id) )
