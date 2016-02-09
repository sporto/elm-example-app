module Actions (..) where

import Routing
import Models exposing (PlayerPerkToggle)
import Perks.Actions
import Perks.List
import PerksPlayers.Actions
import Players.Actions
import Players.Models exposing (PlayerId)


{-
Main level actions that our application can handle
-}


type Action
  = NoOp
    -- Actions relacted to routing, e.g. change page location
  | RoutingAction Routing.Action
    -- Actions related to the Players modules
  | PlayersAction Players.Actions.Action
    -- Actions related to the Perks modules
  | PerksAction Perks.Actions.Action
    -- Actions related to the PerksPlayers modules
  | PerksPlayersAction PerksPlayers.Actions.Action
    -- Actions related specifically to the Perk List module
  | PerksListAction Perks.List.Action
    -- A general action to show flash errors when something bad happens
  | ShowError String
    -- When we delete a player we want to ask for confirmation from the user
  | AskForDeleteConfirmation ( PlayerId, String )
    -- Add or remove a perk from a player
  | TogglePlayerPerk PlayerPerkToggle
