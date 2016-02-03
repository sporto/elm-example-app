module Players.Update (..) where

import Hop
import Effects exposing (Effects)
import Players.Actions exposing (..)
import Players.Models exposing (Player)
import CommonEffects
import Actions as MainActions


update : Action -> List Player -> ( List Player, Effects Action, Effects MainActions.Action )
update action collection =
  case action of
    FetchAllDone result ->
      case result of
        Ok players ->
          ( players, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( [], Effects.none, CommonEffects.showError message )

    EditPlayer id ->
      let
        path =
          "/players/" ++ (toString id) ++ "/edit"
      in
        ( collection, Effects.map HopAction (Hop.navigateTo path), Effects.none )

    IncreaseLevel id ->
      ( changeLevel collection id 1, Effects.none, Effects.none )

    DecreaseLevel id ->
      ( changeLevel collection id -1, Effects.none, Effects.none )

    _ ->
      ( collection, Effects.none, Effects.none )


changeLevel : List Player -> Int -> Int -> List Player
changeLevel players playerId howMuch =
  let
    updater player =
      if player.id == playerId then
        let
          newLevel =
            List.maximum [ 1, player.level + howMuch ]
              |> Maybe.withDefault 1
        in
          { player | level = newLevel }
      else
        player
  in
    List.map updater players
