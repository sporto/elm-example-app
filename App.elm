module App where

import Effects exposing (Effects, Never)
import Html
import Html.Events as Events
import Http
import StartApp
import Task

type Action =
  NoOp

type alias Model = {
    players: List String,
    perks: List String
  }

initialModel = {
    players = [],
    perks = []
  }

view : Signal.Address Action -> Model -> Html.Html
view address model =  
  Html.div [] [
    Html.button [

    ]
    [
      Html.text "Refresh"
    ]
  ]

--httpTask : Task.Task Http.Error String
--httpTask =
--  Http.getString "http://localhost:3000/"

--refreshFx : Effects.Effects Action
--refreshFx =
--  httpTask
--    |> Task.toResult
--    |> Task.map OnRefresh
--    |> Effects.task

init : (Model, Effects Action)
init =
  (initialModel, Effects.none)

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case Debug.log "action" action of
    _ ->
      (model, Effects.none)

app : StartApp.App Model
app = 
  StartApp.start {
    init = init,
    inputs = [],
    update = update,
    view = view
  }

main: Signal.Signal Html.Html
main =
  app.html

port runner : Signal (Task.Task Never ())
port runner =
  app.tasks
