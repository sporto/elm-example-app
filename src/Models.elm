module Models exposing (..)


type alias Model =
    { players : List Player
    }


initialModel : Model
initialModel =
    { players = [ Player "1" "Sam" 1 ]
    }


type alias PlayerId =
    String


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


new : Player
new =
    { id = "0"
    , name = ""
    , level = 1
    }
