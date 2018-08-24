module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation exposing (Key)
import Html exposing (Html, div, text)
import Commands exposing (fetchPlayers)
import Models exposing (Model, PlayerId, initialModel)
import Msgs exposing (Msg)
import Pages.Edit
import Pages.List
import Routing
import Update exposing (update)
import Url exposing (Url)
import RemoteData



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


-- VIEWS



view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ page model ]
    }


page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Pages.List.view model.players

        Models.PlayerRoute id ->
            playerEditPage model id

        Models.NotFoundRoute ->
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
