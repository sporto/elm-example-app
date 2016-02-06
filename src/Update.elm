module Update (..) where

import Effects exposing (Effects, Never)
import Task exposing (Task)
import Actions exposing (..)
import Mailboxes exposing (deleteConfirmationMailbox)
import Models exposing (Model)
import Perks.List
import Perks.Update
import PerksPlayers.Update
import PerksPlayers.Actions
import Players.Actions
import Players.Update
import Routing exposing (router)


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  case Debug.log "action" action of
    -- Send all routing actions to the Routing module
    RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing
      in
        ( { model | routing = updatedRouting }, Effects.map RoutingAction fx )

    -- Send Player actions to the Players module
    -- Some modules return a tuple with three values
    -- The third value is a root level effect to perform
    PlayersAction subAction ->
      let
        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update subAction model.players

        allFx =
          Effects.batch [ (Effects.map PlayersAction fx), fx2 ]
      in
        ( { model | players = updatedPlayers }, allFx )

    -- Send Perk actions to the Perks module
    PerksAction subAction ->
      let
        ( updatedPerks, fx, fx2 ) =
          Perks.Update.update subAction model.perks

        allFx =
          Effects.batch [ (Effects.map PerksAction fx), fx2 ]
      in
        ( { model | perks = updatedPerks }, allFx )

    -- Send PerkPlayer actions to the PerksPlayers module
    PerksPlayersAction subAction ->
      let
        ( updatedPerksPlayers, fx, fx2 ) =
          PerksPlayers.Update.update subAction model.perksPlayers

        allFx =
          Effects.batch [ (Effects.map PerksPlayersAction fx), fx2 ]
      in
        ( { model | perksPlayers = updatedPerksPlayers }, allFx )

    -- Specific actions for the Perk List component
    PerksListAction subAction ->
      let
        ( updatedPerkListModel, fx ) =
          Perks.List.update subAction model.perksListModel
      in
        ( { model | perksListModel = updatedPerkListModel }, Effects.map PerksListAction fx )

    ShowError message ->
      ( { model | errorMessage = message }, Effects.none )

    AskForDeleteConfirmation playerId message ->
      let
        fx =
          Signal.send deleteConfirmationMailbox.address ( playerId, message )
            |> Task.map (always NoOp)
            |> Effects.task
      in
        ( model, fx )

    GetDeleteConfirmation playerId ->
      let
        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update (Players.Actions.GetDeleteConfirmation playerId) model.players
      in
        ( { model | players = updatedPlayers }, Effects.map PlayersAction fx )

    TogglePlayerPerk playerId perkId value ->
      let
        fx =
          Task.succeed (PerksPlayers.Actions.TogglePlayerPerk playerId perkId value)
            |> Effects.task
            |> Effects.map PerksPlayersAction
      in
        ( model, fx )

    _ ->
      ( model, Effects.none )
