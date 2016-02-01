module Routing (..) where

import Effects exposing (Effects, Never)
import Hop


type Action
  = HopAction Hop.Action
  | ShowUsers Hop.Payload
  | ShowUser Hop.Payload
  | ShowPerks Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | NoOp


type View
  = Players
  | Perks
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

    ShowUsers payload ->
      ( { model | view = Players, routerPayload = payload }, Effects.none )

    ShowPerks payload ->
      ( { model | view = Perks, routerPayload = payload }, Effects.none )

    _ ->
      ( model, Effects.none )


routes : List ( String, Hop.Payload -> Action )
routes =
  [ ( "/", ShowUsers )
  , ( "/players", ShowUsers )
  , ( "/perks", ShowPerks )
  ]


router : Hop.Router Action
router =
  Hop.new
    { routes = routes
    , notFoundAction = ShowNotFound
    }
