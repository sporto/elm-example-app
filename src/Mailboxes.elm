module Mailboxes (..) where

{-
A mailbox where we can send a message so
we can open a window confirmation dialogue
-}


deleteConfirmationMailbox : Signal.Mailbox ( Int, String )
deleteConfirmationMailbox =
  Signal.mailbox ( 0, "" )
