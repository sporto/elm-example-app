module Routing exposing (matchers, parseLocation, playerPath, playersPath)

import Models exposing (PlayerId, Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PlayersRoute top
        , map PlayerRoute (s "players" </> string)
        , map PlayersRoute (s "players")
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
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
