module PerksPlayers.Effects (..) where

import Effects exposing (Effects)
import Http
import Json.Decode as Decode exposing ((:=))
import Task
import PerksPlayers.Models exposing (PerkPlayer)
import PerksPlayers.Actions as Actions


fetchAll : Effects Actions.Action
fetchAll =
  Http.get collectionDecoder fetchAllUrl
    |> Task.toResult
    |> Task.map Actions.FetchAllDone
    |> Effects.task


fetchAllUrl : String
fetchAllUrl =
  "http://localhost:4000/perks_players"


collectionDecoder : Decode.Decoder (List PerkPlayer)
collectionDecoder =
  Decode.list memberDecoder


memberDecoder : Decode.Decoder PerkPlayer
memberDecoder =
  Decode.object3
    PerkPlayer
    ("id" := Decode.int)
    ("perkId" := Decode.int)
    ("playerId" := Decode.int)
