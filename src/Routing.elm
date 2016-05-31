module Routing exposing (..)

import Navigation
import Hop exposing (matchUrl)
import Hop.Types exposing (Config, Location, PathMatcher, Router, newLocation)
import Hop.Matchers exposing (match1, match2, match3, int)
import Messages exposing (Msg)
import Players.Models exposing (PlayerId)


{-
   Available routes in our application.
   NotFound is necessary when no route matches the browser path.
-}


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute


type alias Model =
    { location : Location
    , route : Route
    }



{-
   Route matchers

   This are in charge of matching the browser path to our routes defined above.
   e.g. "/players" --> PlayersRoute
-}


indexMatcher : PathMatcher Route
indexMatcher =
    match1 PlayersRoute ""


playersMatcher : PathMatcher Route
playersMatcher =
    match1 PlayersRoute "/players"


playerEditMatch : PathMatcher Route
playerEditMatch =
    match2 PlayerRoute "/players/" int


matchers : List (PathMatcher Route)
matchers =
    [ indexMatcher
    , playersMatcher
    , playerEditMatch
    ]


routerConfig : Config Route
routerConfig =
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFoundRoute
    }


parser : Navigation.Parser ( Route, Hop.Types.Location )
parser =
    Navigation.makeParser (.href >> matchUrl routerConfig)
