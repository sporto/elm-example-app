module Shared exposing (Model, Msg(..), Player, PlayerId, RemoteData(..), Route(..), initialModel, mapRemoteData)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Url exposing (Url)


type alias Model =
    { players : RemoteData (List Player)
    , key : Key
    , route : Route
    }


initialModel : Route -> Key -> Model
initialModel route key =
    { players = Loading
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
    = OnFetchPlayers (Result Http.Error (List Player))
    | OnUrlChange Url
    | OnUrlRequest UrlRequest
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)


type RemoteData a
    = NotAsked
    | Loading
    | Loaded a
    | Failure


mapRemoteData : (a -> b) -> RemoteData a -> RemoteData b
mapRemoteData fn remoteData =
    case remoteData of
        NotAsked ->
            NotAsked

        Loading ->
            Loading

        Loaded data ->
            Loaded (fn data)

        Failure ->
            Failure
