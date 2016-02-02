module Models (..) where

import Perks.Models
import Players.Models
import PerksPlayers.Models
import Perks.List
import Routing


type alias Model =
  { routing : Routing.Model
  , perks : List Perks.Models.Perk
  , perksPlayers : List PerksPlayers.Models.PerkPlayer
  , players : List Players.Models.Player
  , perksListModel : Perks.List.Model
  , currentPlayer : Int
  , errorMessage : String
  }


initialModel : Model
initialModel =
  { routing = Routing.initialModel
  , perks = []
  , perksPlayers = []
  , players = []
  , perksListModel = Perks.List.initialModel
  , currentPlayer = 1
  , errorMessage = ""
  }
