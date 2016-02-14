module Models (..) where

import Players.Models exposing (Player)
import Routing


type alias AppModel =
  { players : List Player
  , routing : Routing.Model
  , errorMessage : String
  }


initialModel : AppModel
initialModel =
  { players = []
  , routing = Routing.initialModel
  , errorMessage = ""
  }
