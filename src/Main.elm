module Main (..) where

import Effects exposing (Effects, Never)
import Html as H
import Html.Events as Events
import Html.Attributes exposing (class)
import StartApp
import Task exposing (Task)
import Perks.Models
import Players.Actions
import Players.Models
import Players.Update
import Players.List
import Perks.Actions
import Players.Effects
import Perks.List
import PerksPlayers.Models
import Routing exposing (router)


-- MODEL


type alias Model =
  { routing : Routing.Model
  , perks : List Perks.Models.Perk
  , perksPlayers : List PerksPlayers.Models.PerkPlayer
  , players : List Players.Models.Player
  , perksListModel : Perks.List.Model
  }


initialModel : Model
initialModel =
  { routing = Routing.initialModel
  , perks =
      [ { id = 1
        , name = "Amulet"
        , bonus = 1
        , description = "Lorem ipsum"
        }
      , { id = 2
        , name = "Shield"
        , bonus = 1
        , description = "Lorem ipsum"
        }
      ]
  , perksPlayers =
      [ { id = 1
        , playerId = 1
        , perkId = 1
        }
      ]
  , players = []
  , perksListModel = Perks.List.initialModel
  }



-- ACTIONS


type Action
  = NoOp
  | RoutingAction Routing.Action
  | PlayersAction Players.Actions.Action
  | PerksAction Perks.Actions.Action
  | PerksListAction Perks.List.Action



-- UPDATE


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  case Debug.log "action" action of
    RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing
      in
        ( { model | routing = updatedRouting }, Effects.map RoutingAction fx )

    PlayersAction subAction ->
      let
        ( updatedPlayers, fx ) =
          Players.Update.update subAction model.players
      in
        ( { model | players = updatedPlayers }, Effects.map PlayersAction fx )

    PerksListAction subAction ->
      let
        ( updatedPerkListModel, fx ) =
          Perks.List.update subAction model.perksListModel
      in
        ( { model | perksListModel = updatedPerkListModel }, Effects.map PerksListAction fx )

    _ ->
      ( model, Effects.none )



-- VIEW


view : Signal.Address Action -> Model -> H.Html
view address model =
  H.div
    []
    [ nav address model
    , page address model
    ]


nav : Signal.Address Action -> Model -> H.Html
nav address model =
  let
    activeClass view =
      if model.routing.view == view then
        "btn-primary"
      else
        ""
  in
    H.div
      [ class "p2"
      ]
      [ H.button
          [ class ("btn button-narrow mr1 " ++ activeClass Routing.Players)
          , Events.onClick (Signal.forwardTo address RoutingAction) (Routing.NavigateTo "/players")
          ]
          [ H.text "Players"
          ]
      , H.button
          [ class ("btn button-narrow " ++ activeClass Routing.Perks)
          , Events.onClick (Signal.forwardTo address RoutingAction) (Routing.NavigateTo "/perks")
          ]
          [ H.text "Perks"
          ]
      ]


page : Signal.Address Action -> Model -> H.Html
page address model =
  case model.routing.view of
    Routing.Players ->
      Players.List.view (Signal.forwardTo address PlayersAction) model.players

    Routing.Perks ->
      let
        perksListModel =
          model.perksListModel

        updatedPerksListModel =
          { perksListModel | perks = model.perks, perksPlayers = model.perksPlayers }
      in
        Perks.List.view (Signal.forwardTo address PerksListAction) updatedPerksListModel

    _ ->
      H.div
        []
        [ H.text "Not found"
        ]


init : ( Model, Effects Action )
init =
  let
    fx =
      Effects.map PlayersAction Players.Effects.fetchAll
  in
    ( initialModel, fx )


routerSignal : Signal Action
routerSignal =
  Signal.map RoutingAction router.signal


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , inputs = [ routerSignal ]
    , update = update
    , view = view
    }


main : Signal.Signal H.Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks


port routeRunTask : Task () ()
port routeRunTask =
  router.run
