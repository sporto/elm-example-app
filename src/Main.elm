module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation as Nav exposing (Key)
import Data exposing (fetchPlayers)
import Html exposing (Html, div, text)
import Pages.Edit
import Pages.List
import RemoteData
import Routes
import Shared exposing (..)
import Url exposing (Url)


type alias Flags =
    {}


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        currentRoute =
            Routes.parseUrl url
    in
    ( initialModel currentRoute key, fetchPlayers )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        OnUrlChange url ->
            let
                newRoute =
                    Routes.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )

        ChangeLevel player howMuch ->
            let
                updatedPlayer =
                    { player | level = player.level + howMuch }
            in
            ( model, Data.savePlayerCmd updatedPlayer )

        OnPlayerSave (Ok player) ->
            ( updatePlayer model player, Cmd.none )

        OnPlayerSave (Err error) ->
            ( model, Cmd.none )


updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer

            else
                currentPlayer

        updatePlayerList players =
            List.map pick players

        updatedPlayers =
            RemoteData.map updatePlayerList model.players
    in
    { model | players = updatedPlayers }



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }



-- VIEWS


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ page model ]
    }


page : Model -> Html Msg
page model =
    case model.route of
        PlayersRoute ->
            Pages.List.view model.players

        PlayerRoute id ->
            playerEditPage model id

        NotFoundRoute ->
            notFoundView


playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    case model.players of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success players ->
            let
                maybePlayer =
                    players
                        |> List.filter (\player -> player.id == playerId)
                        |> List.head
            in
            case maybePlayer of
                Just player ->
                    Pages.Edit.view player

                Nothing ->
                    notFoundView

        RemoteData.Failure err ->
            text "Error"


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
