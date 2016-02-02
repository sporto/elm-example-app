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
  , errorMessage : String
  }


initialModel : Model
initialModel =
  { routing = Routing.initialModel
  , perks =
      [ { id = 1
        , name = "Amulet"
        , bonus = 1
        , description = "Lorem ipsum"
        }
      , { id = 2
        , name = "Shield"
        , bonus = 1
        , description = "Lorem ipsum"
        }
      ]
  , perksPlayers =
      [ { id = 1
        , playerId = 1
        , perkId = 1
        }
      ]
  , players = []
  , perksListModel = Perks.List.initialModel
  , errorMessage = ""
  }
