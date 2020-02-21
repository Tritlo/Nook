
module Main where

import System.Console.GetOpt
import System.Environment


import Control.Monad (when)
import Data.List (elem)

import System.Exit

nookVersion :: String
nookVersion = "0.0.1"

header :: String
header = "Use the following options to interact with Nook ("
       ++ nookVersion ++"):"

options :: [OptDescr Flag]
options =
  [ Option ['q'] ["query"] (ReqArg Query "TYPE")
      "The type to query for"
  , Option ['m'] ["module"] (ReqArg Module "MODULE")
      "Modules that should be in scope"
  , Option ['?'] ["help"] (NoArg Help)
      "Print this help message"
  , Option ['v'] ["version"] (NoArg Version)
      "Print the version"
  ]


data Flag = Query String
          | Module String
          | Help
          | Version
          deriving (Eq, Ord, Show)


main :: IO ()
main = do args <- getArgs
          let (opts, _, errs) = getOpt (ReturnInOrder Query) options args
          when (not $ null errs) $ do
            _ <- sequenceA $ map putStrLn errs
            exitFailure
          when (Help `elem` opts) $ do
            putStrLn $ usageInfo header options
            exitSuccess
          when (Version `elem` opts) $ do
            putStrLn $ "Nook version " ++ nookVersion
            exitSuccess
          print $ opts
