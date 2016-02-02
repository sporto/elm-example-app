module Actions (..) where

import Routing
import Players.Actions
import Perks.Actions
import Perks.List


type Action
  = NoOp
  | RoutingAction Routing.Action
  | PlayersAction Players.Actions.Action
  | PerksAction Perks.Actions.Action
  | PerksListAction Perks.List.Action
  | ShowError String
