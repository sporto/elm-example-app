module Perks.List (..) where

import Html exposing (..)
import Html.Attributes exposing (class, colspan)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Perks.Models exposing (PerkId, Perk)
import PerksPlayers.Models exposing (PerkPlayer)


type alias ViewModel =
  { expandedPerkIds : List PerkId
  , perks : List Perk
  , perksPlayers : List PerkPlayer
  }


initialModel : ViewModel
initialModel =
  { expandedPerkIds = []
  , perks = []
  , perksPlayers = []
  }



-- ACTION


type Action
  = Expand PerkId
  | Collapse PerkId



-- UPDATE


update : Action -> ViewModel -> ( ViewModel, Effects.Effects Action )
update action model =
  case action of
    Expand id ->
      let
        updateExanded =
          id :: model.expandedPerkIds
      in
        ( { model | expandedPerkIds = updateExanded }, Effects.none )

    Collapse id ->
      let
        updateExanded =
          List.filter (\i -> i /= id) model.expandedPerkIds
      in
        ( { model | expandedPerkIds = updateExanded }, Effects.none )



-- VIEW


view : Signal.Address Action -> ViewModel -> Html.Html
view address model =
  let
    rows =
      List.map (perkRow address model) model.perks
  in
    table
      [ class "table-light" ]
      (tableHead
        :: rows
      )


tableHead : Html.Html
tableHead =
  thead
    []
    [ tr
        []
        [ th [] [ text "Id" ]
        , th [] [ text "Name" ]
        , th [] [ text "Bonus" ]
        , th [] [ text "Player count" ]
        , th [] [ text "Actions" ]
        ]
    ]


perkRow : Signal.Address Action -> ViewModel -> Perk -> Html.Html
perkRow address model perk =
  tbody
    []
    [ tr
        []
        [ td [] [ text (toString perk.id) ]
        , td [] [ text perk.name ]
        , td [] [ text (toString perk.bonus) ]
        , td [] [ text (toString (userCountForPerk model.perksPlayers perk)) ]
        , td
            []
            [ toggle address model perk
            ]
        ]
    , (perkRowDescription model perk)
    ]


perkRowDescription : ViewModel -> Perk -> Html.Html
perkRowDescription model perk =
  if isPerkExpanded model.expandedPerkIds perk then
    tr
      []
      [ td [] []
      , td [ colspan 3, class "py2" ] [ text perk.description ]
      ]
  else
    span [] []


toggle : Signal.Address Action -> ViewModel -> Perk -> Html.Html
toggle address model perk =
  if isPerkExpanded model.expandedPerkIds perk then
    button [ class "btn btn-outline", onClick address (Collapse perk.id) ] [ i [ class "fa fa-chevron-down mr1" ] [], text "Collapse" ]
  else
    button [ class "btn btn-outline", onClick address (Expand perk.id) ] [ i [ class "fa fa-chevron-right mr1" ] [], text "Expand" ]



-- UTILS
{-
Given a list of expanded perk ids
And a perk
Determine if that perk should be expanded
-}


isPerkExpanded : List PerkId -> Perk -> Bool
isPerkExpanded expanded perk =
  List.any (\i -> i == perk.id) expanded



{-
Get the number of users for a perk
-}


userCountForPerk : List PerkPlayer -> Perk -> Int
userCountForPerk perksPlayers perk =
  perksPlayers
    |> List.filter (\perkPlayer -> perkPlayer.perkId == perk.id)
    |> List.length
