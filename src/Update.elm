module Update (..) where

import Effects exposing (Effects)
import Debug
import Models exposing (..)
import Actions exposing (..)
import Routing
import Players.Update
import Perks.Update
import Perks.List
import PerksPlayers.Update
import Mailboxes exposing (..)


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case (Debug.log "action" action) of
    RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing
      in
        ( { model | routing = updatedRouting }, Effects.map RoutingAction fx )

    PlayersAction subAction ->
      let
        updateModel =
          { players = model.players
          , showErrorAddress = Signal.forwardTo actionsMailbox.address ShowError
          , deleteConfirmationAddress = askDeleteConfirmationMailbox.address
          }

        ( updatedPlayers, fx ) =
          Players.Update.update subAction updateModel
      in
        ( { model | players = updatedPlayers }, Effects.map PlayersAction fx )

    PerksAction subAction ->
      let
        updateModel =
          { perks = model.perks
          , showErrorAddress = Signal.forwardTo actionsMailbox.address ShowError
          }

        ( updatedPerks, fx ) =
          Perks.Update.update subAction updateModel
      in
        ( { model | perks = updatedPerks }, Effects.map PerksAction fx )

    PerksPlayersAction subAction ->
      let
        updateModel =
          { perksPlayers = model.perksPlayers
          , showErrorAddress = Signal.forwardTo actionsMailbox.address ShowError
          }

        ( updatedPerksPlayers, fx ) =
          PerksPlayers.Update.update subAction updateModel
      in
        ( { model | perksPlayers = updatedPerksPlayers }, Effects.map PerksPlayersAction fx )

    -- Specific actions for the Perk List component
    PerksListAction subAction ->
      let
        ( updatedPerkListModel, fx ) =
          Perks.List.update subAction model.perksListModel
      in
        ( { model | perksListModel = updatedPerkListModel }, Effects.map PerksListAction fx )

    ShowError message ->
      ( { model | errorMessage = message }, Effects.none )

    NoOp ->
      ( model, Effects.none )
