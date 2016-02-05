module PerksPlayers.Update (..) where

import Effects exposing (Effects)
import PerksPlayers.Actions exposing (..)
import PerksPlayers.Models exposing (PerkPlayer)
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
          ( updatedCollection, fx, Effects.none )

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



-- TODO move to utils perkPlayerIdFor


perkPlayerIdFor : Int -> Int -> List PerkPlayer -> Maybe Int
perkPlayerIdFor playerId perkId collection =
  collection
    |> List.filter (\perkPlayer -> perkPlayer.playerId == playerId && perkPlayer.perkId == perkId)
    |> List.map (\perkPlayer -> perkPlayer.id)
    |> List.head


removePerkPlayer : Int -> Int -> List PerkPlayer -> ( List PerkPlayer, Effects Action )
removePerkPlayer playerId perkId collection =
  let
    maybePerkPlayerId =
      perkPlayerIdFor playerId perkId collection

    updatedCollectionAndFx =
      case maybePerkPlayerId of
        Just perkPlayerId ->
          let
            updatedCollection =
              List.filter (\perkPlayer -> perkPlayer.id /= perkPlayerId) collection

            fx =
              PerksPlayers.Effects.delete perkPlayerId
          in
            ( updatedCollection, fx )

        Nothing ->
          ( collection, Effects.none )
  in
    updatedCollectionAndFx


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
