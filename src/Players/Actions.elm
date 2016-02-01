module Players.Actions (..) where

import Http
import Players.Models exposing (Player)


type Action
  = NoOp
  | FetchAll
  | FetchAllSuccess (Result Http.Error (List Player))
