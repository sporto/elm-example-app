module Utils (..) where

--import Effects
--sendAsEffect : Maybe (Signal.Address a) -> a -> (() -> b) -> Effects.Effects b
--sendAsEffect address' value action =
--  case address' of
--    Just address ->
--      Signal.send address value
--        |> Effects.task
--        |> Effects.map action
--    Nothing ->
--      Effects.none
--sendAsEffect : Maybe (Signal.Address a) -> a -> (() -> b) -> Effects.Effects b
--sendAsEffect address' value action =
--  case address' of
--    Just address ->
--      Signal.send address value
--        |> Effects.task
--        |> Effects.map action
--    Nothing ->
--      Effects.none


foo =
  1
