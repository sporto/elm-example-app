module PerksPlayers.Utils (..) where

import Players.Models exposing (PlayerId)
import Perks.Models exposing (PerkId)
import PerksPlayers.Models exposing (PerkPlayerId, PerkPlayer)


{-
Find if a player has a particular perk id
-}


doesPlayerIdHasPerkId : PlayerId -> PerkId -> List PerkPlayer -> Bool
doesPlayerIdHasPerkId playerId perkId collection =
  perksPlayersFor playerId perkId collection
    |> List.isEmpty
    |> not



{-
Find perks for a player id
-}


perksPlayersFor : PlayerId -> PerkId -> List PerkPlayer -> List PerkPlayer
perksPlayersFor playerId perkId collection =
  collection
    |> List.filter (\perkPlayer -> perkPlayer.playerId == playerId && perkPlayer.perkId == perkId)
