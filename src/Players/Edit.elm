module Players.Edit (..) where

import Html as H
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Players.Models exposing (Player)
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)
import Players.Actions as PlayersActions
import Players.Utils as Utils


type alias ViewModel =
  { player : Player
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> H.Html
view address model =
  let
    player =
      model.player

    bonuses =
      Utils.bonusesForPlayerId model.perksPlayers model.perks model.player.id

    strength =
      model.player.level + bonuses
  in
    H.div
      [ class "m2" ]
      [ H.h1 [] [ H.text model.player.name ]
      , H.div
          [ class "clearfix py1"
          ]
          [ H.div [ class "col col-5" ] [ H.text "Level" ]
          , H.div
              [ class "col col-7" ]
              [ H.span [ class "h2 bold" ] [ H.text (toString player.level) ]
              , H.a [ class "btn btn-outline ml1", onClick address (PlayersActions.ChangeLevel player.id -1) ] [ H.text "-" ]
              , H.a [ class "btn btn-outline ml1", onClick address (PlayersActions.ChangeLevel player.id 1) ] [ H.text "+" ]
              ]
          ]
      , H.div
          [ class "clearfix py1" ]
          [ H.div [ class "col col-5" ] [ H.text "Bonuses" ]
          , H.div [ class "col col-7 h2" ] [ H.text (toString bonuses) ]
          ]
      , H.div
          [ class "clearfix py1" ]
          [ H.div [ class "col col-5" ] [ H.text "Strength" ]
          , H.div [ class "col col-7 h2 bold" ] [ H.text (toString strength) ]
          ]
      , H.div
          [ class "clearfix py1"
          ]
          [ H.div [ class "col col-5" ] [ H.text "Name" ]
          , H.div
              [ class "col col-7" ]
              [ H.input [ class "field-light" ] []
              ]
          ]
      , H.div
          [ class "clearfix py1"
          ]
          [ H.div [ class "col col-5" ] [ H.text "Perks" ]
          , H.div [ class "col col-7" ] []
          ]
      ]
