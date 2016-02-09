module PerksPlayers.Update (..) where

import Effects exposing (Effects)
import Perks.Models exposing (PerkId)
import PerksPlayers.Actions exposing (..)
import PerksPlayers.Effects
import PerksPlayers.Models exposing (PerkPlayerId, PerkPlayer)
import Players.Models exposing (PlayerId)


type alias UpdateModel =
  { perksPlayers : List PerkPlayer
  , showErrorAddress : Signal.Address String
  }


update : Action -> UpdateModel -> ( List PerkPlayer, Effects Action )
update action model =
  case action of
    FetchAllDone result ->
      case result of
        Ok perksPlayers ->
          ( perksPlayers, Effects.none )

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

    TogglePlayerPerk toggle ->
      let
        fx =
          if toggle.value then
            addPerkPlayerFx toggle.playerId toggle.perkId
          else
            removePerkPlayerFx toggle.playerId toggle.perkId model.perksPlayers
      in
        ( model.perksPlayers, fx )

    CreatePerkPlayerDone result ->
      case result of
        Ok perkPlayer ->
          let
            updatedCollection =
              perkPlayer :: model.perksPlayers
          in
            ( updatedCollection, Effects.none )

        Err error ->
          let
            message =
              toString error

            fx =
              Signal.send model.showErrorAddress message
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( model.perksPlayers, fx )

    DeletePerkPlayerDone perkPlayerId result ->
      case result of
        Ok _ ->
          let
            updatedCollection =
              List.filter (\item -> item.id /= perkPlayerId) model.perksPlayers
          in
            ( updatedCollection, Effects.none )

        Err error ->
          let
            message =
              toString error

            fx =
              Signal.send model.showErrorAddress message
                |> Effects.task
                |> Effects.map TaskDone
          in
            ( model.perksPlayers, fx )

    _ ->
      ( model.perksPlayers, Effects.none )



{-
Given
- A player id
- A perk id
- List of perksPlayers
Return an effect to delete the perkPlayer(s) from api
-}


removePerkPlayerFx : PlayerId -> PerkId -> List PerkPlayer -> Effects Action
removePerkPlayerFx playerId perkId collection =
  let
    filter perkPlayer =
      perkPlayer.playerId == playerId && perkPlayer.perkId == perkId
  in
    collection
      |> List.filter filter
      |> List.map (\perkPlayer -> PerksPlayers.Effects.delete perkPlayer.id)
      |> Effects.batch



{-
Given
- A player id
- A perk id
Return an effect to create a perkPlayer
-}


addPerkPlayerFx : PlayerId -> PerkId -> Effects Action
addPerkPlayerFx playerId perkId =
  let
    perkPlayer =
      { id = 0
      , playerId = playerId
      , perkId = perkId
      }
  in
    PerksPlayers.Effects.create perkPlayer
