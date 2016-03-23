module Main (..) where

import Html exposing (..)
import Effects exposing (Effects, Never)
import Task
import StartApp
import Actions exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)
import Routing
import Players.Effects
import Players.Actions
import Perks.Effects
import PerksPlayers.Effects
import Mailboxes exposing (..)


init : ( AppModel, Effects Action )
init =
  let
    fxs =
      [ Effects.map PlayersAction Players.Effects.fetchAll
      , Effects.map PerksAction Perks.Effects.fetchAll
      , Effects.map PerksPlayersAction PerksPlayers.Effects.fetchAll
      ]

    fx =
      Effects.batch fxs
  in
    ( Models.initialModel, fx )


routerSignal : Signal Action
routerSignal =
  Signal.map RoutingAction Routing.signal



{-
Pull values from getDeleteConfirmation (port)
Map to DeletePlayer action
-}


getDeleteConfirmationSignal : Signal Actions.Action
getDeleteConfirmationSignal =
  let
    toAction id =
      id
        |> Players.Actions.DeletePlayer
        |> PlayersAction
  in
    Signal.map toAction getDeleteConfirmation


app : StartApp.App AppModel
app =
  StartApp.start
    { init = init
    , inputs = [ routerSignal, actionsMailbox.signal, getDeleteConfirmationSignal ]
    , update = update
    , view = view
    }


main : Signal.Signal Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks


port routeRunTask : Task.Task () ()
port routeRunTask =
  Routing.run



{-
pull values from askDeleteConfirmationMailbox
Send to JS
-}


port askDeleteConfirmation : Signal ( Int, String )
port askDeleteConfirmation =
  askDeleteConfirmationMailbox.signal



{- Get confirmation from JS -}


port getDeleteConfirmation : Signal Int
