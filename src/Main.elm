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
import Perks.Update
import PerksPlayers.Effects
import PerksPlayers.Update
import Players.Actions
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

    Actions.PerksAction subAction ->
      let
        ( updatedPerks, fx, fx2 ) =
          Perks.Update.update subAction model.perks

        allFx =
          Effects.batch [ (Effects.map Actions.PerksAction fx), fx2 ]
      in
        ( { model | perks = updatedPerks }, allFx )

    Actions.PerksPlayersAction subAction ->
      let
        ( updatedPerksPlayers, fx, fx2 ) =
          PerksPlayers.Update.update subAction model.perksPlayers

        allFx =
          Effects.batch [ (Effects.map Actions.PerksPlayersAction fx), fx2 ]
      in
        ( { model | perksPlayers = updatedPerksPlayers }, allFx )

    Actions.PerksListAction subAction ->
      let
        ( updatedPerkListModel, fx ) =
          Perks.List.update subAction model.perksListModel
      in
        ( { model | perksListModel = updatedPerkListModel }, Effects.map Actions.PerksListAction fx )

    Actions.ShowError message ->
      ( { model | errorMessage = message }, Effects.none )

    Actions.AskForDeleteConfirmation playerId message ->
      let
        fx =
          Signal.send deleteConfirmationMailbox.address ( playerId, message )
            |> Task.map (always Actions.NoOp)
            |> Effects.task
      in
        ( model, fx )

    Actions.GetDeleteConfirmation playerId ->
      let
        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update (Players.Actions.GetDeleteConfirmation playerId) model.players
      in
        ( { model | players = updatedPlayers }, Effects.map Actions.PlayersAction fx )

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
    , inputs = [ routerSignal, getDeleteConfirmationSignal ]
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


deleteConfirmationMailbox : Signal.Mailbox ( Int, String )
deleteConfirmationMailbox =
  Signal.mailbox ( 0, "" )


port askForDeleteConfirmation : Signal ( Int, String )
port askForDeleteConfirmation =
  deleteConfirmationMailbox.signal


getDeleteConfirmationSignal : Signal Actions.Action
getDeleteConfirmationSignal =
  Signal.map (\id -> Actions.GetDeleteConfirmation id) getDeleteConfirmation


port getDeleteConfirmation : Signal Int
