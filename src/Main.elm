module Main (..) where

import Effects exposing (Effects, Never)
import Html as H
import StartApp
import Task exposing (Task)
import Actions
import View
import Models exposing (Model)
import Perks.Effects
import Perks.List
import PerksPlayers.Effects
import Players.Effects
import Players.Update
import Routing exposing (router)


-- UPDATE


update : Actions.Action -> Model -> ( Model, Effects.Effects Actions.Action )
update action model =
  case Debug.log "action" action of
    Actions.RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing
      in
        ( { model | routing = updatedRouting }, Effects.map Actions.RoutingAction fx )

    Actions.PlayersAction subAction ->
      let
        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update subAction model.players

        allFx =
          Effects.batch [ (Effects.map Actions.PlayersAction fx), fx2 ]
      in
        ( { model | players = updatedPlayers }, allFx )

    Actions.PerksListAction subAction ->
      let
        ( updatedPerkListModel, fx ) =
          Perks.List.update subAction model.perksListModel
      in
        ( { model | perksListModel = updatedPerkListModel }, Effects.map Actions.PerksListAction fx )

    Actions.ShowError message ->
      ( { model | errorMessage = message }, Effects.none )

    _ ->
      ( model, Effects.none )


init : ( Model, Effects Actions.Action )
init =
  let
    fxs =
      [ Effects.map Actions.PlayersAction Players.Effects.fetchAll
      , Effects.map Actions.PerksAction Perks.Effects.fetchAll
      , Effects.map Actions.PerksPlayersAction PerksPlayers.Effects.fetchAll
      ]

    fx =
      Effects.batch fxs
  in
    ( Models.initialModel, fx )


routerSignal : Signal Actions.Action
routerSignal =
  Signal.map Actions.RoutingAction router.signal


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , inputs = [ routerSignal ]
    , update = update
    , view = View.view
    }


main : Signal.Signal H.Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks


port routeRunTask : Task () ()
port routeRunTask =
  router.run
