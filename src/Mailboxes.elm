module Mailboxes (..) where

import Actions exposing (..)


actionsMailbox : Signal.Mailbox Action
actionsMailbox =
  Signal.mailbox NoOp
