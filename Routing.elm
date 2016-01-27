module Routing where

import Effects exposing (Effects, Never)
import Dict
import Hop

type Action
  = HopAction Hop.Action
  | ShowUsers Hop.Payload
  | ShowUser Hop.Payload
  | ShowPerks Hop.Payload
  | ShowNotFound Hop.Payload
  | NavigateTo String
  | NoOp

type alias Model = {
    routerPayload : Hop.Payload,
    view: String
  }

initialModel : Model
initialModel = {
    routerPayload = router.payload,
    view = "Users"
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NavigateTo path ->
      (model, Effects.map HopAction (Hop.navigateTo path))
    ShowUsers payload ->
      ({model | view = "users", routerPayload = payload}, Effects.none)
    ShowPerks payload ->
      ({model | view = "perks", routerPayload = payload}, Effects.none)
    _ ->
      (model, Effects.none)

routes : List (String, Hop.Payload -> Action)
routes =
  [
    ("/", ShowUsers),
    ("/users", ShowUsers),
    ("/perks", ShowPerks)
  ]

router : Hop.Router Action
router =
  Hop.new {
    routes = routes,
    notFoundAction = ShowNotFound
  }
