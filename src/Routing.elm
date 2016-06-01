module Routing exposing (..)

import String
import Navigation
import UrlParser exposing (..)
import Players.Models exposing (PlayerId)


{-|
   Available routes in our application.
   NotFound is necessary when no route matches the browser path.
-}
type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute


{-|
   Create a routing model where to store the current location and route
-}
type alias Model =
    { route : Route
    }


{-|
   This matcher will match "/players" which is the list of players
-}
matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ format PlayersRoute (s "")
        , format PlayerRoute (s "players" </> int)
        , format PlayersRoute (s "players")
        ]


{-|
   The Navigation package expects a parser for the current location
   Each time the location changes in the browser this package
   will gives us a Navigation.Location record

  In this parser:

  - We extract the .href attribute from the given Location record
  - Send this attribute to Hop.matchUrl

  Hop.matchUrl will return back a tuple with the matched route
  and a Hop.Types.Location record

-}
hashParser : Navigation.Location -> Result String Route
hashParser location =
    parse identity matchers (String.dropLeft 1 location.hash)


parser : Navigation.Parser (Result String Route)
parser =
    Navigation.makeParser hashParser


routeFromResult : Result String Route -> Route
routeFromResult result =
    case result of
        Ok route ->
            route

        Err string ->
            NotFoundRoute
