module Players.Update exposing (..)

import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player)
import Players.Commands exposing (save)
import Navigation


update : Msg -> List Player -> ( List Player, Cmd Msg )
update action players =
    case action of
        FetchAllDone newPlayers ->
            ( newPlayers, Cmd.none )

        FetchAllFail error ->
            ( players, Cmd.none )

        ShowPlayers ->
            ( players, Navigation.modifyUrl "#players" )

        ShowPlayer id ->
            ( players, Navigation.modifyUrl ("#players/" ++ (toString id)) )

        ChangeLevel id howMuch ->
            let
                cmdForPlayer existingPlayer =
                    if existingPlayer.id == id then
                        save { existingPlayer | level = existingPlayer.level + howMuch }
                    else
                        Cmd.none

                commands =
                    List.map cmdForPlayer players
            in
                ( players, Cmd.batch commands )

        SaveSuccess updatedPlayer ->
            ( updatePlayer players updatedPlayer, Cmd.none )

        SaveFail error ->
            ( players, Cmd.none )


updatePlayer : List Player -> Player -> List Player
updatePlayer existingPlayers updatedPlayer =
    let
        select existingPlayer =
            if existingPlayer.id == updatedPlayer.id then
                updatedPlayer
            else
                existingPlayer
    in
        List.map select existingPlayers
