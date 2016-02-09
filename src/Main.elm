module Main (..) where

import Effects exposing (Effects, Never)
import Html as H
import StartApp
import Task exposing (Task)
import Actions
import View
import Update
import Mailboxes exposing (..)
import Models exposing (Model)
import Perks.Effects
import PerksPlayers.Effects
import Players.Effects
import Routing exposing (router)


{-
Provide a list of initial effects to run
Load all application data
-}


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



{-
Signal provider by the router
This carries actions after location changes
-}


routerSignal : Signal Actions.Action
routerSignal =
  Signal.map Actions.RoutingAction router.signal



{-
Standard StarApp setup
Inputs:
  - routerSignal: actions from router
  - getDeleteConfirmationSignal:  Response from user clicking on window confirmation dialogue
-}


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , inputs = [ routerSignal, getDeleteConfirmationSignal, perksPlayersChangeMailbox.signal ]
    , update = Update.update
    , view = View.view
    }


main : Signal.Signal H.Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks



{-
port to run tasks provided by the router
i.e. changing the window location
-}


port routeRunTask : Task () ()
port routeRunTask =
  router.run



{-
Port to send a message to JS
JS will open a window.confirm diagloue
-}


port askForDeleteConfirmation : Signal ( Int, String )
port askForDeleteConfirmation =
  deleteConfirmationMailbox.signal



{- Map message comming from getDeleteConfirmation port
to the right action i.e. GetDeleteConfirmation

Question: Can this be done more generic? i.e. map to different actions
-}


getDeleteConfirmationSignal : Signal Actions.Action
getDeleteConfirmationSignal =
  Signal.map (\id -> Actions.GetDeleteConfirmation id) getDeleteConfirmation



{- Get confirmation from JS -}


port getDeleteConfirmation : Signal Int
