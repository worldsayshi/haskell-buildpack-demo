{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Text (Text)
import Data.Text.Lazy (unpack)
import Happstack.Lite
import Text.Blaze.Html5 (Html, (!), div, a, form, input, p, toHtml, label)
import Text.Blaze.Html5.Attributes (action, enctype, href, name, size, type_, value)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Control.Exception as Ex
import System.Environment (getEnv)

import Style (mycss)

main :: IO ()
main = do
  let getPort = Ex.catch (getEnv "PORT")
          ((\_-> do
               -- This is mainly for deploying to heroku
              putStrLn "PORT environment variable not set, defaulting to 8080"
              return "8080") :: IOError -> IO String)
  appPort <- getPort
  let conf = defaultServerConfig { port = read appPort }
  serve (Just conf) myApp

myApp :: ServerPart Response
myApp = let
  styles = path $ \p ->
    case p :: Text of
      "style.css" -> ok $ toResponse mycss
      _ -> notFound $ toResponse ("Error: 404" :: Text)
  -- serving a static file
  fileServing :: ServerPart Response
  fileServing =
     serveDirectory EnableBrowsing ["index.html"] "static"
  in msum
        [
          dir "style"   $ styles,
          dir "static"   $ fileServing,
          homePage
        ]

homePage :: ServerPart Response
homePage =
     ok $ template "home page" $ do
       H.h1 "Hello!"
       H.p "Hi"

template :: Text -> Html -> Response
template title body = toResponse $
   H.html $ do
     H.head $ do
       H.title (toHtml title)
       H.link
         ! A.href "style/style.css"
         ! A.type_ "text/css"
         ! A.rel "stylesheet"
     H.body $ do
       H.div ! A.id "content" $ do
         body
       p $ a ! href "/" $ "back home"



