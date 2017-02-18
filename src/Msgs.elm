module Msgs exposing (..)

import Models exposing (Player, PlayerId)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ShowPlayers
    | ShowPlayer PlayerId
