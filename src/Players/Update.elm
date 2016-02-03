module Players.Update (..) where

import Hop
import Effects exposing (Effects)
import Players.Actions exposing (..)
import Players.Models exposing (Id, Player)
import Players.Effects
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

    ChangeLevel id howMuch ->
      let
        updatedCollectionWithFxs =
          changeLevel collection id howMuch

        updatedCollection =
          List.map fst updatedCollectionWithFxs

        fxs =
          List.map snd updatedCollectionWithFxs
            |> Effects.batch
      in
        ( updatedCollection, fxs, Effects.none )

    ChangeName id name ->
      let
        updatedCollectionWithFxs =
          changeName collection id name

        updatedCollection =
          List.map fst updatedCollectionWithFxs

        fxs =
          List.map snd updatedCollectionWithFxs
            |> Effects.batch
      in
        ( updatedCollection, fxs, Effects.none )

    _ ->
      ( collection, Effects.none, Effects.none )


changeLevel : List Player -> Id -> Int -> List ( Player, Effects Action )
changeLevel players playerId howMuch =
  let
    updater player =
      if player.id == playerId then
        let
          newLevel =
            List.maximum [ 1, player.level + howMuch ]
              |> Maybe.withDefault 1

          updatedPlayer =
            { player | level = newLevel }
        in
          ( updatedPlayer, Players.Effects.saveOne updatedPlayer )
      else
        ( player, Effects.none )
  in
    List.map updater players


changeName : List Player -> Id -> String -> List ( Player, Effects Action )
changeName players playerId name =
  let
    updater player =
      if player.id == playerId then
        let
          updatedPlayer =
            { player | name = name }
        in
          ( updatedPlayer, Players.Effects.saveOne updatedPlayer )
      else
        ( player, Effects.none )
  in
    List.map updater players
