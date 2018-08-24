module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation as Nav exposing (Key)
import Data exposing (fetchPlayers)
import Html exposing (Html, a, div, section, text)
import Html.Attributes exposing (class, href)
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
    let
        content =
            case model.players of
                RemoteData.NotAsked ->
                    text ""

                RemoteData.Loading ->
                    text "Loading ..."

                RemoteData.Success players ->
                    pageWithData model players

                RemoteData.Failure err ->
                    text "Error"
    in
    section []
        [ nav model
        , content
        ]


pageWithData : Model -> List Player -> Html Msg
pageWithData model players =
    case model.route of
        PlayersRoute ->
            Pages.List.view players

        PlayerRoute id ->
            Pages.Edit.view players id

        NotFoundRoute ->
            notFoundView


nav : Model -> Html Msg
nav model =
    let
        links =
            case model.route of
                PlayersRoute ->
                    [ text "Players" ]

                PlayerRoute _ ->
                    [ linkToList
                    ]

                NotFoundRoute ->
                    [ linkToList
                    ]

        linkToList =
            a [ href Routes.playersPath, class "text-white" ] [ text "List" ]
    in
    div
        [ class "mb-2 text-white bg-black p-4" ]
        links


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
