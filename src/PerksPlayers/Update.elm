module PerksPlayers.Update (..) where

import Effects exposing (Effects)
import PerksPlayers.Actions exposing (..)
import PerksPlayers.Models exposing (PerkPlayerId, PerkPlayer)
import CommonEffects
import Actions as MainActions
import PerksPlayers.Effects


update : Action -> List PerkPlayer -> ( List PerkPlayer, Effects Action, Effects MainActions.Action )
update action collection =
  case action of
    FetchAllDone result ->
      case result of
        Ok perksPlayers ->
          ( perksPlayers, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( [], Effects.none, CommonEffects.showError message )

    TogglePlayerPerk toggle ->
      let
        fx =
          if toggle.value then
            addPerkPlayerFx toggle.playerId toggle.perkId
          else
            removePerkPlayerFx toggle.playerId toggle.perkId collection
      in
        ( collection, fx, Effects.none )

    CreatePerkPlayerDone result ->
      case result of
        Ok perkPlayer ->
          let
            updatedCollection =
              perkPlayer :: collection
          in
            ( updatedCollection, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( collection, Effects.none, CommonEffects.showError message )

    DeletePerkPlayerDone perkPlayerId result ->
      case result of
        Ok _ ->
          let
            updatedCollection =
              List.filter (\item -> item.id /= perkPlayerId) collection
          in
            ( updatedCollection, Effects.none, Effects.none )

        Err error ->
          let
            message =
              toString error
          in
            ( collection, Effects.none, CommonEffects.showError message )

    _ ->
      ( collection, Effects.none, Effects.none )


removePerkPlayerFx : Int -> Int -> List PerkPlayer -> Effects Action
removePerkPlayerFx playerId perkId collection =
  let
    filter perkPlayer =
      perkPlayer.playerId == playerId && perkPlayer.perkId == perkId
  in
    collection
      |> List.filter filter
      |> List.map (\perkPlayer -> PerksPlayers.Effects.delete perkPlayer.id)
      |> Effects.batch


addPerkPlayerFx : Int -> Int -> Effects Action
addPerkPlayerFx playerId perkId =
  let
    perkPlayer =
      { id = 0
      , playerId = playerId
      , perkId = perkId
      }
  in
    PerksPlayers.Effects.create perkPlayer
