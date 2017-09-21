module Main where

import Lib
import CLI
import Data.Monoid
import Options.Applicative
import Types
import Control.Monad.Trans.Reader
import Control.Monad.IO.Class
import Checks

main :: IO ()
main = do
  cli <- execParser opts
  flip runReaderT cli $ runAuditor $ do
    res <- parseGenesisFile <$> readGenesisFile
    case res of
      Left e -> error e
      Right genData -> performChecks genData >>= liftIO . print
  where
    opts = info (parseCLI <**> helper)
      ( fullDesc
     <> progDesc "Genesis auditor tool."
     <> header "genesis-auditor" )
