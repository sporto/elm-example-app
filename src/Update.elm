module Update (..) where

import Effects exposing (Effects, Never)
import Task exposing (Task)
import Actions exposing (..)
import Mailboxes exposing (deleteConfirmationMailbox, eventsMailbox)
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
        modelForUpdate =
          { players = model.players
          , showErrorAddress = Signal.forwardTo eventsMailbox.address ShowError
          , perksPlayersChangeAddress = Signal.forwardTo eventsMailbox.address TogglePlayerPerk
          }

        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update subAction modelForUpdate

        allFx =
          Effects.batch [ (Effects.map PlayersAction fx), fx2 ]
      in
        ( { model | players = updatedPlayers }, allFx )

    -- Send Perk actions to the Perks module
    PerksAction subAction ->
      let
        modelForUpdate =
          { perks = model.perks
          , showErrorAddress = Signal.forwardTo eventsMailbox.address ShowError
          }

        ( updatedPerks, fx, fx2 ) =
          Perks.Update.update subAction modelForUpdate

        allFx =
          Effects.batch [ (Effects.map PerksAction fx), fx2 ]
      in
        ( { model | perks = updatedPerks }, allFx )

    -- Send PerkPlayer actions to the PerksPlayers module
    PerksPlayersAction subAction ->
      let
        modelForUpdate =
          { perksPlayers = model.perksPlayers
          , showErrorAddress = Signal.forwardTo eventsMailbox.address ShowError
          }

        ( updatedPerksPlayers, fx, fx2 ) =
          PerksPlayers.Update.update subAction modelForUpdate

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
        -- TODO: this is repeated
        -- TODO, this should flow through PlayersActions
        updateModel =
          { players = model.players
          , showErrorAddress = Signal.forwardTo eventsMailbox.address ShowError
          , perksPlayersChangeAddress = Signal.forwardTo eventsMailbox.address TogglePlayerPerk
          }

        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update (Players.Actions.GetDeleteConfirmation playerId) updateModel
      in
        ( { model | players = updatedPlayers }, Effects.map PlayersAction fx )

    TogglePlayerPerk toggle ->
      let
        fx =
          Task.succeed (PerksPlayers.Actions.TogglePlayerPerk toggle)
            |> Effects.task
            |> Effects.map PerksPlayersAction
      in
        ( model, fx )

    _ ->
      ( model, Effects.none )
