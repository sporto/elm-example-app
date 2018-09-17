module Player exposing (Player, decoder, encode)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Shared exposing (..)


type alias Player =
    { id : String
    , name : String
    , level : Int
    }



-- JSON


decoder : Decode.Decoder Player
decoder =
    Decode.succeed Player
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "level" Decode.int


encode : Player -> Encode.Value
encode player =
    let
        attributes =
            [ ( "id", Encode.string player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
    Encode.object attributes
