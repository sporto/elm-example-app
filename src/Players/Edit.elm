module Players.Edit (..) where

import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (on, onClick, onKeyPress, targetValue)
import Players.Models exposing (Player)
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)
import Players.Actions as PlayersActions
import Players.Utils as Utils
import Players.Edit.Perks


type alias ViewModel =
  { player : Player
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


view : Signal.Address PlayersActions.Action -> ViewModel -> Html.Html
view address model =
  let
    player =
      model.player

    bonuses =
      Utils.bonusesForPlayerId model.perksPlayers model.perks model.player.id

    strength =
      model.player.level + bonuses
  in
    div
      [ class "m2" ]
      [ h1 [] [ text model.player.name ]
      , div
          [ class "clearfix py1"
          ]
          [ div [ class "col col-5" ] [ text "Level" ]
          , div
              [ class "col col-7" ]
              [ span [ class "h2 bold" ] [ text (toString player.level) ]
              , a
                  [ class "btn btn-outline ml1"
                  , onClick address (PlayersActions.ChangeLevel player.id -1)
                  ]
                  [ text "-" ]
              , a
                  [ class "btn btn-outline ml1"
                  , onClick address (PlayersActions.ChangeLevel player.id 1)
                  ]
                  [ text "+" ]
              ]
          ]
      , div
          [ class "clearfix py1" ]
          [ div [ class "col col-5" ] [ text "Bonuses" ]
          , div [ class "col col-7 h2" ] [ text (toString bonuses) ]
          ]
      , div
          [ class "clearfix py1" ]
          [ div [ class "col col-5" ] [ text "Strength" ]
          , div [ class "col col-7 h2 bold" ] [ text (toString strength) ]
          ]
      , div
          [ class "clearfix py1"
          ]
          [ div [ class "col col-5" ] [ text "Name" ]
          , div
              [ class "col col-7" ]
              [ input
                  [ class "field-light"
                  , value player.name
                  , onChange address (PlayersActions.ChangeName player.id)
                  ]
                  []
              ]
          ]
      , div
          [ class "clearfix py1"
          ]
          [ div [ class "col col-5" ] [ text "Perks" ]
          , div
              [ class "col col-7" ]
              [ perksList address model
              ]
          ]
      ]


perksList : Signal.Address PlayersActions.Action -> ViewModel -> Html.Html
perksList address model =
  let
    viewModel =
      { playerId = model.player.id
      , perks = model.perks
      , perksPlayers = model.perksPlayers
      }
  in
    Players.Edit.Perks.view address viewModel



-- TODO change to address << Action


onChange : Signal.Address a -> (String -> a) -> Attribute
onChange address action =
  on "change" targetValue (\str -> Signal.message address (action str))
