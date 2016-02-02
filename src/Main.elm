module Main (..) where

import Effects exposing (Effects, Never)
import Html as H
import Html.Events as Events
import Html.Attributes exposing (class)
import StartApp
import String
import Task exposing (Task)
import Actions
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
  , errorMessage : String
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
  , errorMessage = ""
  }



-- UPDATE


update : Actions.Action -> Model -> ( Model, Effects.Effects Actions.Action )
update action model =
  case Debug.log "action" action of
    Actions.RoutingAction subAction ->
      let
        ( updatedRouting, fx ) =
          Routing.update subAction model.routing
      in
        ( { model | routing = updatedRouting }, Effects.map Actions.RoutingAction fx )

    Actions.PlayersAction subAction ->
      let
        ( updatedPlayers, fx, fx2 ) =
          Players.Update.update subAction model.players

        allFx =
          Effects.batch [ (Effects.map Actions.PlayersAction fx), fx2 ]
      in
        ( { model | players = updatedPlayers }, allFx )

    Actions.PerksListAction subAction ->
      let
        ( updatedPerkListModel, fx ) =
          Perks.List.update subAction model.perksListModel
      in
        ( { model | perksListModel = updatedPerkListModel }, Effects.map Actions.PerksListAction fx )

    Actions.ShowError message ->
      ( { model | errorMessage = message }, Effects.none )

    _ ->
      ( model, Effects.none )



-- VIEW


view : Signal.Address Actions.Action -> Model -> H.Html
view address model =
  H.div
    []
    [ nav address model
    , flash address model
    , page address model
    ]


nav : Signal.Address Actions.Action -> Model -> H.Html
nav address model =
  let
    activeClass view =
      if model.routing.view == view then
        "bg-white black"
      else
        ""
  in
    H.div
      [ class "clearfix mb2 bg-blue white"
      ]
      [ H.div
          [ class "left" ]
          [ H.button
              [ class ("btn py2 button-narrow mr1 " ++ activeClass Routing.Players)
              , Events.onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/players")
              ]
              [ H.text "Players"
              ]
          , H.button
              [ class ("btn py2 button-narrow " ++ activeClass Routing.Perks)
              , Events.onClick (Signal.forwardTo address Actions.RoutingAction) (Routing.NavigateTo "/perks")
              ]
              [ H.text "Perks"
              ]
          ]
      ]


flash : Signal.Address Actions.Action -> Model -> H.Html
flash address model =
  if String.isEmpty model.errorMessage then
    H.span [] []
  else
    H.div [ class "bold center p2 mb2 white bg-red rounded" ] [ H.text model.errorMessage ]


page : Signal.Address Actions.Action -> Model -> H.Html
page address model =
  case model.routing.view of
    Routing.Players ->
      Players.List.view (Signal.forwardTo address Actions.PlayersAction) model.players

    Routing.Perks ->
      let
        perksListModel =
          model.perksListModel

        updatedPerksListModel =
          { perksListModel | perks = model.perks, perksPlayers = model.perksPlayers }
      in
        Perks.List.view (Signal.forwardTo address Actions.PerksListAction) updatedPerksListModel

    _ ->
      H.div
        []
        [ H.text "Not found"
        ]


init : ( Model, Effects Actions.Action )
init =
  let
    fx =
      Effects.map Actions.PlayersAction Players.Effects.fetchAll
  in
    ( initialModel, fx )


routerSignal : Signal Actions.Action
routerSignal =
  Signal.map Actions.RoutingAction router.signal


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
