module Players.Models (..) where


type alias Id =
  Int


type alias Player =
  { id : Id
  , name : String
  , level : Int
  }


new : Player
new =
  { id = 0
  , name = ""
  , level = 1
  }
