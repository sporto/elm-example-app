module CommonEffects (..) where

import Task exposing (..)
import Effects exposing (Effects)
import Actions


showError : String -> Effects Actions.Action
showError message =
  Task.succeed (Actions.ShowError message)
    |> Effects.task


togglePlayerPerk : Int -> Int -> Bool -> Effects Actions.Action
togglePlayerPerk playerId perkId value =
  Task.succeed (Actions.TogglePlayerPerk playerId perkId value)
    |> Effects.task
