{-# LANGUAGE
    OverloadedStrings
  #-}
module Style (mycss) where

import Clay

mycss = render $ p ?
        do
          color red
          background white
