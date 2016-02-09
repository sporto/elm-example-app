module Models (..) where

import Perks.Models exposing (..)
import Players.Models exposing (..)
import PerksPlayers.Models exposing (..)
import Perks.List
import Routing


{-
The main application model
This model contains all the resource collections in our application
e.g. perks, players
And application data
e.g. routing, currentPlay, errorMessage
-}


type alias Model =
  { routing : Routing.Model
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  , players : List Player
  , perksListModel : Perks.List.ViewModel
  , currentPlayer : PlayerId
  , errorMessage : String
  }


type alias PlayerPerkToggle =
  { playerId : PlayerId
  , perkId : PerkId
  , value : Bool
  }


initialModel : Model
initialModel =
  { routing = Routing.initialModel
  , perks = []
  , perksPlayers = []
  , players = []
  , perksListModel = Perks.List.initialModel
  , currentPlayer = 1
  , errorMessage = ""
  }
