module Mailboxes (..) where

import Actions exposing (..)


actionsMailbox : Signal.Mailbox Action
actionsMailbox =
  Signal.mailbox NoOp


askDeleteConfirmationMailbox : Signal.Mailbox ( Int, String )
askDeleteConfirmationMailbox =
  Signal.mailbox ( 0, "" )
