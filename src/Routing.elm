module Routing (..) where

import Effects exposing (Effects, Never)
import Hop


type Action
  = HopAction Hop.Action
  | ShowPlayers Hop.Payload
  | EditPlayer Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | NoOp


type AvailableViews
  = PlayersView
  | EditPlayerView
  | NotFoundView


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
