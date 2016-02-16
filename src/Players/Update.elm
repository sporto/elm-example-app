module Players.Update (..) where

import Task
import Hop
import Effects exposing (Effects)
import Players.Actions exposing (..)
import Players.Models exposing (..)
import Players.Effects exposing (..)


type alias UpdateModel =
  { players : List Player
  , showErrorAddress : Signal.Address String
  }


update : Action -> UpdateModel -> ( List Player, Effects Action )
update action model =
  case action of
    HopAction payload ->
      ( model.players, Effects.none )

    EditPlayer id ->
      let
        path =
          "/players/" ++ (toString id) ++ "/edit"
      in
        ( model.players, Effects.map HopAction (Hop.navigateTo path) )

    ListPlayers ->
      let
        path =
          "/players/"
      in
        ( model.players, Effects.map HopAction (Hop.navigateTo path) )

    FetchAllDone result ->
      case result of
        Ok players ->
          ( players, Effects.none )

        Err error ->
          let
            errorMessage =
              toString error

            fx =
              Signal.send model.showErrorAddress errorMessage
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( model.players, fx )

    CreatePlayer ->
      ( model.players, create new )

    CreatePlayerDone result ->
      case result of
        Ok player ->
          let
            updatedCollection =
              player :: model.players

            fx =
              Task.succeed (EditPlayer player.id)
                |> Effects.task
          in
            ( updatedCollection, fx )

        Err error ->
          let
            message =
              toString error

            fx =
              Signal.send model.showErrorAddress message
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( model.players, fx )

    TaskDone () ->
      ( model.players, Effects.none )

    NoOp ->
      ( model.players, Effects.none )
