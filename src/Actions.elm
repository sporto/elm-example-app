module Actions (..) where

import Players.Actions


type Action
  = NoOp
  | PlayersAction Players.Actions.Action
