module Players.Messages exposing (..)

import Http
import Players.Models exposing (PlayerId, Player)


type Msg
    = FetchAll (Result Http.Error (List Player))
