module Mailboxes (..) where

import Actions exposing (..)


--import Perks.Models exposing (PerkId)
--import Players.Models exposing (PlayerId)
{-
A mailbox where we can send a message so
we can open a window confirmation dialogue
-}


deleteConfirmationMailbox : Signal.Mailbox ( Int, String )
deleteConfirmationMailbox =
  Signal.mailbox ( 0, "" )



--perksPlayersChangeMailbox : Signal.Mailbox ( PerkId, PlayerId, Bool )
--perksPlayersChangeMailbox =
--  Signal.mailbox ( 0, 0, False )


perksPlayersChangeMailbox : Signal.Mailbox Action
perksPlayersChangeMailbox =
  Signal.mailbox NoOp
