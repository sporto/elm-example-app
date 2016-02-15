module Actions (..) where

import Players.Actions
import Perks.Actions
import PerksPlayers.Actions
import Routing


type Action
  = NoOp
  | RoutingAction Routing.Action
  | PlayersAction Players.Actions.Action
  | PerksAction Perks.Actions.Action
  | PerksPlayersAction PerksPlayers.Actions.Action
  | ShowError String
