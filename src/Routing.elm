module Routing (..) where

import Effects exposing (Effects, Never)
import Hop
import Debug


{-
All Actions related to routing
-}


type
  Action
  -- Actions performed by Hop e.g. changing the location
  = HopAction Hop.Action
    -- Actions that happend after a location change, there are called by Hop
  | ShowPlayers Hop.Payload
  | EditPlayer Hop.Payload
  | ShowPerks Hop.Payload
  | ShowNotFound Hop.Payload
    -- Action to ask for route change
  | NavigateTo String
  | NoOp



{-
All available views in our application
-}


type AvailableViews
  = PlayersView
  | PerksView
  | EditPlayerView
  | NotFoundView



{-
Model related to routing, this holds the router payload given by Hop
and the current view
-}


type alias Model =
  { routerPayload : Hop.Payload
  , view : AvailableViews
  }


initialModel : Model
initialModel =
  { routerPayload = router.payload
  , view = PlayersView
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    -- Called from our application views e.g. by clicking on a button
    -- Asks Hop to change the page location
    NavigateTo path ->
      ( model, Effects.map HopAction (Hop.navigateTo path) )

    -- Actions called after a location change happens
    -- These are triggered by Hop
    ShowPlayers payload ->
      ( { model | view = PlayersView, routerPayload = payload }, Effects.none )

    EditPlayer payload ->
      ( { model | view = EditPlayerView, routerPayload = payload }, Effects.none )

    ShowPerks payload ->
      ( { model | view = PerksView, routerPayload = (Debug.log "" payload) }, Effects.none )

    _ ->
      ( model, Effects.none )



{-
Routes in our application
Each route maps to a view
-}


routes : List ( String, Hop.Payload -> Action )
routes =
  [ ( "/", ShowPlayers )
  , ( "/players", ShowPlayers )
  , ( "/players/:id/edit", EditPlayer )
  , ( "/perks", ShowPerks )
  ]



{-
Create a Hop router
-}


router : Hop.Router Action
router =
  Hop.new
    { routes = routes
    , notFoundAction = ShowNotFound
    }
