module Actions (..) where

import Routing
import Perks.Actions
import Perks.List
import PerksPlayers.Actions
import Players.Actions


type alias PlayerId =
  Int


type alias PerkId =
  Int


type Action
  = NoOp
  | RoutingAction Routing.Action
  | PlayersAction Players.Actions.Action
  | PerksAction Perks.Actions.Action
  | PerksPlayersAction PerksPlayers.Actions.Action
  | PerksListAction Perks.List.Action
  | ShowError String
  | AskForDeleteConfirmation Int String
  | GetDeleteConfirmation Int
  | TogglePlayerPerk PlayerId PerkId Bool
