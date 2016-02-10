module View (..) where

import Html exposing (..)
import Actions exposing (..)
import Models exposing (..)


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    []
    [ text "Hello" ]
