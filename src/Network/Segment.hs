{-# LANGUAGE OverloadedStrings #-}
module Network.Segment where
import Control.Lens                   -- from: lens
import Data.Aeson (toJSON)            -- from: aeson
import Data.Text (Text, unpack)       -- from: text
import Data.Text.Strict.Lens          -- from: lens
import Data.Thyme.Time                -- from: thyme
import Formatting                     -- from: formatting
import qualified Network.Wreq as Wreq -- from: wreq

import Network.Segment.Types

type WriteKey = Text

apiEndpoint :: Format r (Text -> r)
apiEndpoint = "https://api.segment.io/v1/" % stext

sendEvent :: WriteKey -> Event -> IO ()
sendEvent wkey ev@(Event evt _ _) = do
  let url  = unpack . sformat apiEndpoint $ evt ^. re eventType
      opts = Wreq.defaults & Wreq.auth ?~ Wreq.basicAuth (wkey ^. re utf8) ""
  resp <- Wreq.postWith opts url (toJSON $ payload ev)
  print resp
  return ()