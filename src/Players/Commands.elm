module Players.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Players.Messages exposing (..)
import Players.Models exposing (PlayerId, Player)
import Players.Models exposing (PlayerId, Player)
import Task


fetchAll : Cmd Msg
fetchAll =
    Http.get fetchAllUrl collectionDecoder
        |> Http.send FetchAll


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/players"


saveUrl : PlayerId -> String
saveUrl playerId =
    "http://localhost:4000/players/" ++ (toString playerId)


saveTask : Player -> Task.Task Http.Error Player
saveTask player =
    let
        body =
            memberEncoded player
                |> Encode.encode 0
                |> Http.string

        config =
            { verb = "PATCH"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = saveUrl player.id
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson memberDecoder


save : Player -> Cmd Msg
save player =
    saveTask player
        |> Task.perform SaveFail SaveSuccess



-- DECODERS


collectionDecoder : Decode.Decoder (List Player)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Player
memberDecoder =
    Decode.map3 Player
        (field "id" Decode.int)
        (field "name" Decode.string)
        (field "level" Decode.int)


memberEncoded : Player -> Encode.Value
memberEncoded player =
    let
        list =
            [ ( "id", Encode.int player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object
