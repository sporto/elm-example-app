module PerksPlayers.Models (..) where


type alias PerkPlayerId =
  Int


type alias PerkPlayer =
  { id : PerkPlayerId
  , perkId : Int
  , playerId : Int
  }
