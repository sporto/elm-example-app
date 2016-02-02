module CommonEffects (..) where

import Task exposing (..)
import Effects exposing (Effects)
import Actions


showError : String -> Effects Actions.Action
showError message =
  Task.succeed message
    |> Task.map Actions.ShowError
    |> Effects.task
