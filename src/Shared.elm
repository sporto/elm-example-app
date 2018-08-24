module Shared exposing (Model, Msg(..), Player, PlayerId, Route(..), initialModel)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import RemoteData exposing (WebData)
import Url exposing (Url)


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


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnUrlChange Url
    | OnUrlRequest UrlRequest
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
