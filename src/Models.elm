module Models exposing (..)

import Hop.Types exposing (Location)
import Players.Models exposing (Player)
import Routing


type alias Model =
    { players : List Player
    , routing : Routing.Model
    }


initialModel : Location -> Routing.Route -> Model
initialModel location route =
    { players = []
    , routing = Routing.Model location route
    }
