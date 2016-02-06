module Models (..) where

import Perks.Models
import Players.Models
import PerksPlayers.Models
import Perks.List
import Routing


{-
The main application model
This model contains all the resource collections in our application
e.g. perks, players
And application data
e.g. routing, currentPlay, errorMessage
-}


type alias Model =
  { routing : Routing.Model
  , perks : List Perks.Models.Perk
  , perksPlayers : List PerksPlayers.Models.PerkPlayer
  , players : List Players.Models.Player
  , perksListModel : Perks.List.ViewModel
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
