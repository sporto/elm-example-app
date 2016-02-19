module Models (..) where

import Players.Models exposing (Player)
import Perks.Models exposing (Perk)
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


initialModel : AppModel
initialModel =
  { players = []
  , perks = []
  , perksPlayers = []
  , perksListModel = Perks.List.initialModel
  , routing = Routing.initialModel
  , errorMessage = ""
  }
