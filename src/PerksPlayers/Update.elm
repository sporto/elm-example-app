module PerksPlayers.Update (..) where

import Effects exposing (Effects)
import PerksPlayers.Actions exposing (..)
import PerksPlayers.Models exposing (PerkPlayer)
import CommonEffects
import Actions as MainActions
import PerksPlayers.Effects
import PerksPlayers.Utils


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

    TogglePlayerPerk playerId perkId val ->
      if val then
        let
          ( perkPlayer, fx ) =
            addPerkPlayer playerId perkId

          updatedCollection =
            perkPlayer :: collection
        in
          ( updatedCollection, fx, Effects.none )
      else
        let
          ( updatedCollection, fx ) =
            removePerkPlayer playerId perkId collection
        in
          ( updatedCollection, Effects.batch fx, Effects.none )

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

    _ ->
      ( collection, Effects.none, Effects.none )


removePerkPlayer : Int -> Int -> List PerkPlayer -> ( List PerkPlayer, List (Effects Action) )
removePerkPlayer playerId perkId collection =
  let
    mapper perkPlayer =
      if perkPlayer.playerId == playerId && perkPlayer.perkId == perkId then
        -- TODO, send the fx
        ( perkPlayer, PerksPlayers.Effects.delete perkPlayer.id )
      else
        ( perkPlayer, Effects.none )

    updatedCollectionAndFx =
      List.map mapper collection

    updatedCollection =
      List.map fst updatedCollectionAndFx

    fxs =
      List.map snd updatedCollectionAndFx
  in
    ( updatedCollection, fxs )


addPerkPlayer : Int -> Int -> ( PerkPlayer, Effects Action )
addPerkPlayer playerId perkId =
  let
    perkPlayer =
      { id = 0
      , playerId = playerId
      , perkId = perkId
      }

    fx =
      PerksPlayers.Effects.create perkPlayer
  in
    ( perkPlayer, fx )
