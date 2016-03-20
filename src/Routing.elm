module Routing (..) where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import Hop
import Hop.Types exposing (Location, PathMatcher, Router, newLocation)
import Hop.Navigate exposing (navigateTo)
import Hop.Matchers exposing (match1, match2, match3, int)
import Players.Models exposing (PlayerId)


{-
Available routes in our application.
NotFound is necessary when no route matches the browser path.
-}


type Route
  = PlayersRoute
  | PlayerEditRoute PlayerId
  | NotFoundRoute



{-
Routing Actions.

HopAction:
To change the browser location Hop returns a task that need to be run by a port.
We need to wrap this task in an action, but the result of the task is not important, thus the () payload.

ApplyRoute:
When the browser location changes Hop will match the path with the matchers (defined below)
Hop provides a signal of (Route, Location). Where Route our matched route and Location is
a record with information about the current location.

NavigateTo:
Action to start a browser location change.
-}


type Action
  = HopAction ()
  | ApplyRoute ( Route, Location )
  | NavigateTo String



{-
Model used in the module.

We need to store the current location given by Hop. This location is needed
for some navigation and for extracting the current query.

We also store the current route so we can display the correct views.
-}


type alias Model =
  { location : Location
  , route : Route
  }


initialModel : Model
initialModel =
  { location = newLocation
  , route = PlayersRoute
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    {-
    NavigateTo
    Called from our application views e.g. by clicking on a button
    asks Hop to change the page location
    -}
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo path) )

    {-
    ApplyRoute
    When we get a new value from the hop signal, this action is triggered,
    here we store the current route and location into the model.
    -}
    ApplyRoute ( route, location ) ->
      ( { model | route = route, location = location }, Effects.none )

    HopAction () ->
      ( model, Effects.none )



{-
Route matchers

This are in charge of matching the browser path to our routes defined above.
e.g. "/players" --> PlayersRoute
-}


indexMatcher : PathMatcher Route
indexMatcher =
  match1 PlayersRoute "/"


playersMatcher : PathMatcher Route
playersMatcher =
  match1 PlayersRoute "/players"


playerEditMatch : PathMatcher Route
playerEditMatch =
  match3 PlayerEditRoute "/players/" int "/edit"


matchers : List (PathMatcher Route)
matchers =
  [ indexMatcher
  , playersMatcher
  , playerEditMatch
  ]



{-
Create a Hop router
Hop expects a list of matchers and one Route for when there are no matches
-}


router : Router Route
router =
  Hop.new
    { matchers = matchers
    , notFound = NotFoundRoute
    }



{-
In order to change the location on the browser when we first run the application
we need to send a task to a port to do it.
-}


run : Task () ()
run =
  router.run



{-
Hop provides a signal that updated when the browser location changes.
This signal has the type (Route, Location).
Here we map this signal to one our application can use i.e. ApplyRoute (Route, Location)
-}


signal : Signal Action
signal =
  Signal.map ApplyRoute router.signal
