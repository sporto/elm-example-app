module Update (..) where

import Effects exposing (Effects)
import Debug
import Models exposing (..)
import Actions exposing (..)
import Routing
import Players.Update
import Perks.Update
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

    ShowError message ->
      ( { model | errorMessage = message }, Effects.none )

    NoOp ->
      ( model, Effects.none )
