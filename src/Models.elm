module Models (..) where

import Players.Models exposing (PlayerId, Player)
import Perks.Models exposing (PerkId, Perk)
import PerksPlayers.Models exposing (PerkPlayer)
import Perks.List
import Routing


type alias AppModel =
  { players : List Player
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  , perksListModel : Perks.List.ViewModel
  , routing : Routing.Model
  , errorMessage : String
  }


type alias PlayerPerkToggle =
  { playerId : PlayerId
  , perkId : PerkId
  , value : Bool
  }


initialModel : AppModel
initialModel =
  { players = []
  , perks = []
  , perksPlayers = []
  , perksListModel = Perks.List.initialModel
  , routing = Routing.initialModel
  , errorMessage = ""
  }
