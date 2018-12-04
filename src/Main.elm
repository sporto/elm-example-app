module Main exposing (init, main, subscriptions)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, a, div, section, text)
import Html.Attributes exposing (class, href)
import Pages.Edit as Edit
import Pages.List as List
import Routes exposing (Route)
import Shared exposing (..)
import Url exposing (Url)


type alias Model =
    { flags : Flags
    , navKey : Key
    , route : Route
    , page : Page
    }


type Page
    = Page_None
    | Page_List List.Model
    | Page_Edit Edit.Model


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | Msg_List List.Msg
    | Msg_Edit Edit.Msg


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { flags = flags
            , navKey = navKey
            , route = Routes.parseUrl url
            , page = Page_None
            }
    in
    ( model, Cmd.none )
        |> loadCurrentPage


loadCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadCurrentPage ( model, cmd ) =
    let
        ( page, newCmd ) =
            case model.route of
                Routes.PlayersRoute ->
                    let
                        ( pageModel, pageCmd ) =
                            List.init model.flags
                    in
                    ( Page_List pageModel, Cmd.map Msg_List pageCmd )

                Routes.PlayerRoute playerId ->
                    let
                        ( pageModel, pageCmd ) =
                            Edit.init model.flags playerId
                    in
                    ( Page_Edit pageModel, Cmd.map Msg_Edit pageCmd )

                Routes.NotFoundRoute ->
                    ( Page_None, Cmd.none )
    in
    ( { model | page = page }, Cmd.batch [ cmd, newCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        Page_List pageModel ->
            Sub.map Msg_List (List.subscriptions pageModel)

        Page_Edit pageModel ->
            Sub.map Msg_Edit (Edit.subscriptions pageModel)

        Page_None ->
            Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( OnUrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( OnUrlChange url, _ ) ->
            let
                newRoute =
                    Routes.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> loadCurrentPage

        ( Msg_List subMsg, Page_List pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    List.update subMsg pageModel
            in
            ( { model | page = Page_List newPageModel }
            , Cmd.map Msg_List newCmd
            )

        ( Msg_List subMsg, _ ) ->
            ( model, Cmd.none )

        ( Msg_Edit subMsg, Page_Edit pageModel ) ->
            let
                ( newPageModel, newCmd ) =
                    Edit.update model.flags subMsg pageModel
            in
            ( { model | page = Page_Edit newPageModel }
            , Cmd.map Msg_Edit newCmd
            )

        ( Msg_Edit subMsg, _ ) ->
            ( model, Cmd.none )


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
    , body = [ currentPage model ]
    }


currentPage : Model -> Html Msg
currentPage model =
    let
        page =
            case model.page of
                Page_List pageModel ->
                    List.view pageModel
                        |> Html.map Msg_List

                Page_Edit pageModel ->
                    Edit.view pageModel
                        |> Html.map Msg_Edit

                Page_None ->
                    notFoundView
    in
    section []
        [ nav model
        , page
        ]


nav : Model -> Html Msg
nav model =
    let
        links =
            case model.route of
                Routes.PlayersRoute ->
                    [ text "Players" ]

                Routes.PlayerRoute _ ->
                    [ linkToList
                    ]

                Routes.NotFoundRoute ->
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
