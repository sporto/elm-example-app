module PerksPlayers.Utils (..) where

import PerksPlayers.Models exposing (PerkPlayer)


doesPlayerIdHasPerkId : Int -> Int -> List PerkPlayer -> Bool
doesPlayerIdHasPerkId playerId perkId collection =
  perksPlayersFor playerId perkId collection
    |> List.isEmpty
    |> not


perksPlayersFor : Int -> Int -> List PerkPlayer -> List PerkPlayer
perksPlayersFor playerId perkId collection =
  collection
    |> List.filter (\perkPlayer -> perkPlayer.playerId == playerId && perkPlayer.perkId == perkId)
