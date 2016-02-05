module Perks.List (..) where

import Html as H
import Html.Attributes exposing (class, colspan)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Perks.Models exposing (Perk)
import PerksPlayers.Models exposing (PerkPlayer)


-- MODEL
-- TODO change to ViewModel


type alias Model =
  { expanded : List Int
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


initialModel : Model
initialModel =
  { expanded = []
  , perks = []
  , perksPlayers = []
  }



-- ACTION


type Action
  = Expand Int
  | Collapse Int



-- UTILS


isPerkExpanded : List Int -> Perk -> Bool
isPerkExpanded expanded perk =
  List.any (\i -> i == perk.id) expanded



-- UPDATE


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  case action of
    Expand id ->
      let
        updateExanded =
          id :: model.expanded
      in
        ( { model | expanded = updateExanded }, Effects.none )

    Collapse id ->
      let
        updateExanded =
          List.filter (\i -> i /= id) model.expanded
      in
        ( { model | expanded = updateExanded }, Effects.none )



-- VIEW


view : Signal.Address Action -> Model -> H.Html
view address model =
  let
    rows =
      List.map (perkRow address model) model.perks
  in
    H.table
      [ class "table-light" ]
      (tableHead
        :: rows
      )



--:: (List.map (perkRow address model) model.perks)


tableHead : H.Html
tableHead =
  H.thead
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


perkRow : Signal.Address Action -> Model -> Perk -> H.Html
perkRow address model perk =
  H.tbody
    []
    [ H.tr
        []
        [ H.td [] [ H.text (toString perk.id) ]
        , H.td [] [ H.text perk.name ]
        , H.td [] [ H.text (toString perk.bonus) ]
        , H.td [] [ H.text (toString (userCountForPerk model.perksPlayers perk)) ]
        , H.td
            []
            [ toggle address model perk
            ]
        ]
    , (perkRowDescription model perk)
    ]


perkRowDescription : Model -> Perk -> H.Html
perkRowDescription model perk =
  if isPerkExpanded model.expanded perk then
    H.tr
      []
      [ H.td [] []
      , H.td [ colspan 3, class "py2" ] [ H.text perk.description ]
      ]
  else
    H.span [] []


toggle : Signal.Address Action -> Model -> Perk -> H.Html
toggle address model perk =
  if isPerkExpanded model.expanded perk then
    H.button [ class "btn btn-outline", onClick address (Collapse perk.id) ] [ H.text "Collapse" ]
  else
    H.button [ class "btn btn-outline", onClick address (Expand perk.id) ] [ H.text "Expand" ]


userCountForPerk : List PerkPlayer -> Perk -> Int
userCountForPerk perksPlayers perk =
  perksPlayers
    |> List.filter (\perkPlayer -> perkPlayer.perkId == perk.id)
    |> List.length
