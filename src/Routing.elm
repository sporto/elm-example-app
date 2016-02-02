module Routing (..) where

import Effects exposing (Effects, Never)
import Hop


type Action
  = HopAction Hop.Action
  | ShowPlayers Hop.Payload
  | ShowPlayer Hop.Payload
  | EditPlayer Hop.Payload
  | ShowPerks Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | NoOp


type View
  = Players
  | Perks
  | EditPlayerView
  | NotFound


type alias Model =
  { routerPayload : Hop.Payload
  , view : View
  }


initialModel : Model
initialModel =
  { routerPayload = router.payload
  , view = Players
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NavigateTo path ->
      ( model, Effects.map HopAction (Hop.navigateTo path) )

    ShowPlayers payload ->
      ( { model | view = Players, routerPayload = payload }, Effects.none )

    EditPlayer payload ->
      ( { model | view = EditPlayerView, routerPayload = payload }, Effects.none )

    ShowPerks payload ->
      ( { model | view = Perks, routerPayload = payload }, Effects.none )

    _ ->
      ( model, Effects.none )


routes : List ( String, Hop.Payload -> Action )
routes =
  [ ( "/", ShowPlayers )
  , ( "/players", ShowPlayers )
  , ( "/players/:id/edit", EditPlayer )
  , ( "/perks", ShowPerks )
  ]


router : Hop.Router Action
router =
  Hop.new
    { routes = routes
    , notFoundAction = ShowNotFound
    }
