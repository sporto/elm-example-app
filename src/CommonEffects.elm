module CommonEffects (..) where

import Task exposing (..)
import Effects exposing (Effects)
import Actions


{-
When something bad happens we want to show an error in the UI
We return this effect from a view to show the error
-}


showError : String -> Effects Actions.Action
showError message =
  Task.succeed (Actions.ShowError message)
    |> Effects.task



{-
Add or remove a perk from a player
-}


togglePlayerPerk : Int -> Int -> Bool -> Effects Actions.Action
togglePlayerPerk playerId perkId value =
  Task.succeed (Actions.TogglePlayerPerk playerId perkId value)
    |> Effects.task
