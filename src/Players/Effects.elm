module Players.Effects (..) where

import Effects exposing (Effects)
import Http
import Json.Decode as Decode exposing ((:=))
import Task
import Players.Models exposing (Player)
import Players.Actions as Actions


fetchAll : Effects Actions.Action
fetchAll =
  Http.get playersDecoder fetchAllUrl
    |> Task.toResult
    |> Task.map Actions.FetchAllDone
    |> Effects.task


fetchAllUrl : String
fetchAllUrl =
  "http://localhost:4000/players"


playersDecoder : Decode.Decoder (List Player)
playersDecoder =
  Decode.list playerDecoder


playerDecoder : Decode.Decoder Player
playerDecoder =
  Decode.object3
    Player
    ("id" := Decode.int)
    ("name" := Decode.string)
    ("level" := Decode.int)
