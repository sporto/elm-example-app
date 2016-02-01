module Main (..) where

import Effects exposing (Effects, Never)
import Html as H
import Html.Events as Events
import Html.Attributes exposing (class)
import Http
import StartApp
import Task exposing (Task)
import Perks.Models
import Players.Actions
import Players.Models
import Players.List
import Perks.Actions
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
  , players =
      [ { id = 1
        , name = "Sam"
        , level = 1
        }
      ]
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
  H.div
    [ class "p2"
    ]
    [ H.button
        [ class "btn btn-primary mr1"
        , Events.onClick (Signal.forwardTo address RoutingAction) (Routing.NavigateTo "/players")
        ]
        [ H.text "Players"
        ]
    , H.button
        [ class "btn btn-primary"
        , Events.onClick (Signal.forwardTo address RoutingAction) (Routing.NavigateTo "/perks")
        ]
        [ H.text "Perks"
        ]
    ]



--PlayersAction needs to be or PerksListAction


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



--httpTask : Task.Task Http.Error String
--httpTask =
--  Http.getString "http://localhost:3000/"
--refreshFx : Effects.Effects Action
--refreshFx =
--  httpTask
--    |> Task.toResult
--    |> Task.map OnRefresh
--    |> Effects.task


init : ( Model, Effects Action )
init =
  ( initialModel, Effects.none )


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
