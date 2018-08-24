module Msgs exposing (Msg(..))

import Http
import Models exposing (Player, PlayerId)
import Browser exposing (UrlRequest)
import RemoteData exposing (WebData)
import Url exposing (Url)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnUrlChange Url
    | OnUrlRequest UrlRequest
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
