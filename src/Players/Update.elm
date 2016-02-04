module Players.Update (..) where

import Hop
import Effects exposing (Effects)
import Task
import Players.Actions exposing (..)
import Players.Models exposing (Id, Player, new)
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

    CreatePlayer ->
      ( collection, Players.Effects.create new, Effects.none )

    CreatePlayerDone result ->
      case result of
        Ok player ->
          ( player :: collection, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( [], Effects.none, CommonEffects.showError message )

    AskToDeletePlayer player ->
      let
        msg =
          "Are you sure you want to delete " ++ player.name ++ "?"

        fx =
          Task.succeed (MainActions.AskForDeleteConfirmation player.id msg)
            |> Effects.task
      in
        ( collection, Effects.none, fx )

    ChangeLevel id howMuch ->
      let
        updatedCollectionWithFxs =
          changeLevelForPlayerId howMuch collection id

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
          changeNameForPlayerId name collection id

        updatedCollection =
          List.map fst updatedCollectionWithFxs

        fxs =
          List.map snd updatedCollectionWithFxs
            |> Effects.batch
      in
        ( updatedCollection, fxs, Effects.none )

    _ ->
      ( collection, Effects.none, Effects.none )


updatePlayerLevel : Int -> Player -> ( Player, Effects Action )
updatePlayerLevel howMuch player =
  let
    newLevel =
      List.maximum [ 1, player.level + howMuch ]
        |> Maybe.withDefault 1

    updatedPlayer =
      { player | level = newLevel }
  in
    ( updatedPlayer, Players.Effects.saveOne updatedPlayer )


changeLevelForPlayerId : Int -> List Player -> Id -> List ( Player, Effects Action )
changeLevelForPlayerId howMuch =
  changeAttribute (updatePlayerLevel howMuch)


updatePlayerName : String -> Player -> ( Player, Effects Action )
updatePlayerName name player =
  let
    updatedPlayer =
      { player | name = name }
  in
    ( updatedPlayer, Players.Effects.saveOne updatedPlayer )


changeNameForPlayerId : String -> List Player -> Id -> List ( Player, Effects Action )
changeNameForPlayerId name =
  changeAttribute (updatePlayerName name)


changeAttribute : (Player -> ( Player, Effects Action )) -> List Player -> Id -> List ( Player, Effects Action )
changeAttribute callback players playerId =
  let
    mapper player =
      if player.id == playerId then
        callback player
      else
        ( player, Effects.none )
  in
    List.map mapper players
