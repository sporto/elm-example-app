module Msgs exposing (..)

import Models exposing (Player)
import RemoteData exposing (WebData)


type Msg
    = OnFetchPlayers (WebData (List Player))
