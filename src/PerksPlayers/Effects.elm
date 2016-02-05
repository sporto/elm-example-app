module PerksPlayers.Effects (..) where

import Effects exposing (Effects)
import Http
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
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


create : PerkPlayer -> Effects Actions.Action
create perkPlayer =
  let
    body =
      memberEncoder perkPlayer
        |> Encode.encode 0
        |> Http.string

    config =
      { verb = "POST"
      , headers = [ ( "Content-Type", "application/json" ) ]
      , url = createUrl
      , body = body
      }
  in
    Http.send Http.defaultSettings config
      |> Http.fromJson memberDecoder
      |> Task.toResult
      |> Task.map Actions.CreatePerkPlayerDone
      |> Effects.task


createUrl : String
createUrl =
  "http://localhost:4000/perks_players"


delete : Int -> Effects Actions.Action
delete id =
  deleteTask id
    |> Task.toResult
    |> Task.map (Actions.DeletePerkPlayerDone id)
    |> Effects.task


deleteTask : Int -> Task.Task Http.RawError Http.Response
deleteTask id =
  let
    config =
      { verb = "DELETE"
      , headers = [ ( "Content-Type", "application/json" ) ]
      , url = deleteUrl id
      , body = Http.empty
      }
  in
    Http.send Http.defaultSettings config


deleteUrl : Int -> String
deleteUrl id =
  "http://localhost:4000/perks_players/" ++ (toString id)



-- DECODERS


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


memberEncoder : PerkPlayer -> Encode.Value
memberEncoder perkPlayer =
  let
    list =
      [ ( "id", Encode.int perkPlayer.id )
      , ( "perkId", Encode.int perkPlayer.perkId )
      , ( "playerId", Encode.int perkPlayer.playerId )
      ]
  in
    list
      |> Encode.object
