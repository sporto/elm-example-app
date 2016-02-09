module Mailboxes (..) where

import Actions exposing (..)


{-
A mailbox where we can send a message so
we can open a window confirmation dialogue
-}


deleteConfirmationMailbox : Signal.Mailbox ( Int, String )
deleteConfirmationMailbox =
  Signal.mailbox ( 0, "" )


eventsMailbox : Signal.Mailbox Action
eventsMailbox =
  Signal.mailbox NoOp
