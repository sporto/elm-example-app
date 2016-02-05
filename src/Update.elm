module Update (..) where

import Effects exposing (Effects, Never)
import Html as H
import StartApp
import Task exposing (Task)
import Actions
import View
import Mailboxes exposing (deleteConfirmationMailbox)
import Models exposing (Model)
import Perks.Effects
import Perks.List
import Perks.Update
import PerksPlayers.Effects
import PerksPlayers.Update
import PerksPlayers.Actions
import Players.Actions
import Players.Effects
import Players.Update
import Routing exposing (router)


update : Actions.Action -> Model -> ( Model, Effects.Effects Actions.Action )
update action model =
  case Debug.log "action" action of
    {-
    Send all routing actions to the Routing module
    -}
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

    Actions.TogglePlayerPerk playerId perkId value ->
      let
        fx =
          Task.succeed (PerksPlayers.Actions.TogglePlayerPerk playerId perkId value)
            |> Effects.task
            |> Effects.map Actions.PerksPlayersAction
      in
        ( model, fx )

    _ ->
      ( model, Effects.none )
