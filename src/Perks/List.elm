module Perks.List (..) where

import Html as H
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Perks.Models exposing (Perk)
import Perks.Actions as Actions
import PerksPlayers.Models exposing (PerkPlayer)


-- MODEL


type alias Model =
  { expanded : List Int
  }


initialModel : Model
initialModel =
  { expanded = []
  }



-- ACTION


type Action
  = Expand Int



-- UPDATE


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  ( model, Effects.none )



-- VIEW


view : Signal.Address Actions.Action -> ( List Perk, List PerkPlayer ) -> H.Html
view address ( perks, perksPlayers ) =
  H.table
    [ class "table-light" ]
    [ H.thead
        []
        [ H.tr
            []
            [ H.th [] [ H.text "Id" ]
            , H.th [] [ H.text "Name" ]
            , H.th [] [ H.text "Bonus" ]
            , H.th [] [ H.text "Player count" ]
            , H.th [] [ H.text "Actions" ]
            ]
        ]
    , H.tbody [] (List.map (perkRow address perksPlayers) perks)
    ]


perkRow : Signal.Address Actions.Action -> List PerkPlayer -> Perk -> H.Html
perkRow address perksPlayers perk =
  H.tr
    []
    [ H.td [] [ H.text (toString perk.id) ]
    , H.td [] [ H.text perk.name ]
    , H.td [] [ H.text (toString perk.bonus) ]
    , H.td [] [ H.text (toString (userCountForPerk perksPlayers perk)) ]
    , H.td
        []
        [ H.button
            [ class "btn"
            , onClick address (Expand perk.id)
            ]
            [ H.text "Expand" ]
        ]
    ]


userCountForPerk : List PerkPlayer -> Perk -> Int
userCountForPerk perksPlayers perk =
  perksPlayers
    |> List.filter (\perkPlayer -> perkPlayer.perkId == perk.id)
    |> List.length
