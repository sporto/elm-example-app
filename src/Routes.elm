module Routes exposing (Route(..), parseUrl, playerPath, playersPath)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = PlayersRoute
    | PlayerRoute String
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PlayersRoute top
        , map PlayerRoute (s "players" </> string)
        , map PlayersRoute (s "players")
        ]


parseUrl : Url -> Route
parseUrl url =
    case parse matchers url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


pathFor : Route -> String
pathFor route =
    case route of
        PlayersRoute ->
            "/players"

        PlayerRoute id ->
            "/players/" ++ id

        NotFoundRoute ->
            "/"


playersPath =
    pathFor PlayersRoute


playerPath id =
    pathFor (PlayerRoute id)
