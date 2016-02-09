module Players.Update (..) where

import Hop
import Effects exposing (Effects)
import Task
import Models exposing (PlayerPerkToggle)
import Players.Actions exposing (..)
import Players.Models exposing (PlayerId, Player, new)
import Players.Effects
import Actions as MainActions


type alias UpdateModel =
  { players : List Player
  , perksPlayersChangeAddress : Signal.Address PlayerPerkToggle
  , showErrorAddress : Signal.Address String
  , askForDeleteConfirmationAddress : Signal.Address ( PlayerId, String )
  }


update : Action -> UpdateModel -> ( List Player, Effects Action )
update action model =
  case action of
    FetchAllDone result ->
      case result of
        Ok players ->
          ( players, Effects.none )

        Err error ->
          let
            message =
              toString error

            fx =
              Signal.send model.showErrorAddress message
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( [], fx )

    EditPlayer id ->
      let
        path =
          "/players/" ++ (toString id) ++ "/edit"
      in
        ( model.players, Effects.map HopAction (Hop.navigateTo path) )

    CreatePlayer ->
      ( model.players, Players.Effects.create new )

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
            ( [], fx )

    AskForDeletePlayerConfirmation player ->
      let
        msg =
          "Are you sure you want to delete " ++ player.name ++ "?"

        fx =
          Signal.send model.askForDeleteConfirmationAddress ( player.id, msg )
            |> Effects.task
            |> Effects.map TaskDone
      in
        ( model.players, fx )

    GetDeleteConfirmation playerId ->
      let
        updatedCollection =
          List.filter (\player -> player.id /= playerId) model.players

        fx =
          Players.Effects.delete playerId
      in
        ( updatedCollection, fx )

    ChangeLevel id howMuch ->
      let
        updatedCollectionWithFxs =
          changeLevelForPlayerId howMuch model.players id

        updatedCollection =
          List.map fst updatedCollectionWithFxs

        fxs =
          List.map snd updatedCollectionWithFxs
            |> Effects.batch
      in
        ( updatedCollection, fxs )

    ChangeName id name ->
      let
        updatedCollectionWithFxs =
          changeNameForPlayerId name model.players id

        updatedCollection =
          List.map fst updatedCollectionWithFxs

        fxs =
          List.map snd updatedCollectionWithFxs
            |> Effects.batch
      in
        ( updatedCollection, fxs )

    TogglePlayerPerk playerId perkId value ->
      let
        toggle =
          { playerId = playerId
          , perkId = perkId
          , value = value
          }

        fx =
          Signal.send model.perksPlayersChangeAddress toggle
            |> Effects.task
            |> Effects.map TaskDone
      in
        ( model.players, fx )

    _ ->
      ( model.players, Effects.none )


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


changeLevelForPlayerId : Int -> List Player -> PlayerId -> List ( Player, Effects Action )
changeLevelForPlayerId howMuch =
  changeAttribute (updatePlayerLevel howMuch)


updatePlayerName : String -> Player -> ( Player, Effects Action )
updatePlayerName name player =
  let
    updatedPlayer =
      { player | name = name }
  in
    ( updatedPlayer, Players.Effects.saveOne updatedPlayer )


changeNameForPlayerId : String -> List Player -> PlayerId -> List ( Player, Effects Action )
changeNameForPlayerId name =
  changeAttribute (updatePlayerName name)


changeAttribute : (Player -> ( Player, Effects Action )) -> List Player -> PlayerId -> List ( Player, Effects Action )
changeAttribute callback players playerId =
  let
    mapper player =
      if player.id == playerId then
        callback player
      else
        ( player, Effects.none )
  in
    List.map mapper players
