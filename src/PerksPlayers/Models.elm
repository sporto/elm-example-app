module PerksPlayers.Models (..) where

import Players.Models exposing (PlayerId)
import Perks.Models exposing (PerkId)


type alias PerkPlayerId =
  Int


type alias PerkPlayer =
  { id : PerkPlayerId
  , perkId : PerkId
  , playerId : PlayerId
  }
