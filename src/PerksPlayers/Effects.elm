module PerksPlayers.Effects (..) where

import Effects exposing (Effects)
import Http
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Task
import Perks.Models exposing (PerkId)
import Players.Models exposing (PlayerId)
import PerksPlayers.Models exposing (PerkPlayer)
import PerksPlayers.Actions exposing (..)


fetchAll : Effects Action
fetchAll =
  Http.get collectionDecoder fetchAllUrl
    |> Task.toResult
    |> Task.map FetchAllDone
    |> Effects.task


fetchAllUrl : String
fetchAllUrl =
  "http://localhost:4000/perks_players"


create : PerkPlayer -> Effects Action
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
      |> Task.map CreatePerkPlayerDone
      |> Effects.task


createUrl : String
createUrl =
  "http://localhost:4000/perks_players"


delete : Int -> Effects Action
delete id =
  deleteTask id
    |> Task.toResult
    |> Task.map (DeletePerkPlayerDone id)
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



{-
Given
- A player id
- A perk id
- List of perksPlayers
Return an effect to delete the perkPlayer(s) from api
-}


removePerkPlayerFx : PlayerId -> PerkId -> List PerkPlayer -> Effects Action
removePerkPlayerFx playerId perkId collection =
  let
    filter perkPlayer =
      perkPlayer.playerId == playerId && perkPlayer.perkId == perkId
  in
    collection
      |> List.filter filter
      |> List.map (\perkPlayer -> delete perkPlayer.id)
      |> Effects.batch



{-
Given
- A player id
- A perk id
Return an effect to create a perkPlayer
-}


addPerkPlayerFx : PlayerId -> PerkId -> Effects Action
addPerkPlayerFx playerId perkId =
  let
    perkPlayer =
      { id = 0
      , playerId = playerId
      , perkId = perkId
      }
  in
    create perkPlayer
