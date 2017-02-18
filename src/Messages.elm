module Messages exposing (..)

import Http
import Models exposing (Player)
import RemoteData exposing (WebData)


type Msg
    = OnFetchPlayers (WebData (List Player))
