module Models (..) where

import Players.Models exposing (Player)


type alias AppModel =
  { players : List Player
  }


initialModel : AppModel
initialModel =
  { players = [ Player 1 "Sam" 1 ]
  }
