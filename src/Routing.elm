module Routing exposing (matchers, parseUrl, playerPath, playersPath)

import Models exposing (PlayerId, Route(..))
-- import Browser.Navigation exposing (Location)
import Url exposing (Url)
import Url.Parser exposing (..)


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


playersPath : String
playersPath =
    "#players"


playerPath : PlayerId -> String
playerPath id =
    "#players/" ++ id
