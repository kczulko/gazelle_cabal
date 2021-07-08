{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
module Cabal2Build.Options
  ( Options(..)
  , parseCommandLine
  ) where

import Options.Applicative
import Path (Abs, File, Path, parseAbsFile)

data Options = Options
  { cabalFiles :: [Path Abs File]
  }

parseCommandLine :: IO Options
parseCommandLine = execParser $
    info
      (parser <**> helper)
      (fullDesc
         <> progDesc
              (mconcat
                 [ "Prints in stdout information extracted from cabal files"
                 , " in JSON format."
                 ]
              )
         <> header "cabalscan - extract build information from cabal files"
      )
  where
    parser = Options
      <$> some (argument someFile (metavar "CABAL_FILES..."))

    someFile :: ReadM (Path Abs File)
    someFile = eitherReader $ \s ->
      case parseAbsFile s of
        Just f -> Right f
        Nothing -> Left $ "couldn't parse absolute file path: " ++ s
