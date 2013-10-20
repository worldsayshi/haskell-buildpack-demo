{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative ((<$>), optional)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Text.Lazy (unpack)
import Happstack.Lite
import Text.Blaze.Html5 (Html, (!), a, form, input, p, toHtml, label)
import Text.Blaze.Html5.Attributes (action, enctype, href, name, size, type_, value)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Control.Exception
import System.Environment
import Prelude hiding (catch)

import Cl



main :: IO ()
main = do
  appPort <- getPort
  let conf = defaultServerConfig { port = read appPort }
  serve (Just conf) myApp



myApp :: ServerPart Response
myApp = msum
        [
          dir "style"   $ styles,
          dir "files"   $ fileServing,
          homePage
        ]

homePage :: ServerPart Response
homePage =
     ok $ template "home page" $ do
            H.h1 "Hello!"

fileServing :: ServerPart Response
fileServing =
     serveDirectory EnableBrowsing ["index.html"] "."

template :: Text -> Html -> Response
template title body = toResponse $
   H.html $ do
     H.head $ do
       H.title (toHtml title)
     H.body $ do
       body
       p $ a ! href "/" $ "back home"

styles = path foo

foo :: String -> ServerPart Response
foo p =
  if p=="style.css"
  then ok $ toResponse $
       -- It's clay!
       (foocss)
       --       ("foo {bar: baz}"::Text)
  else ok $ toResponse (""::Text)


getPort = catch (getEnv "PORT")
          (\e-> do
              putStrLn (show (e :: IOError))
              return "8080")

{-
import System.Environment
import Network.HTTP.Types (status200)
import Network.Wai
import Network.Wai.Handler.Warp (run)

application _ = return $
  responseLBS status200 [("Content-Type", "text/plain")] "Hello world.\n\nThis is Haskell on Heroku.\nhttps://github.com/pufuwozu/haskell-buildpack-demo"

main = do
  port <- getEnv "PORT"
  run (fromIntegral $ read port) application
-}
