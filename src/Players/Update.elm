module Players.Update exposing (..)

import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player)


update : Msg -> List Player -> ( List Player, Cmd Msg )
update message players =
    case message of
        FetchAll (Ok newPlayers) ->
            ( newPlayers, Cmd.none )

        FetchAll (Err error) ->
            ( players, Cmd.none )
