module Models exposing (Model, Player, PlayerId, Route(..), initialModel)

import Browser.Navigation exposing (Key)
import RemoteData exposing (WebData)


type alias Model =
    { players : WebData (List Player)
    , key : Key
    , route : Route
    }


initialModel : Route -> Key -> Model
initialModel route key =
    { players = RemoteData.Loading
    , key = key
    , route = route
    }


type alias PlayerId =
    String


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute
