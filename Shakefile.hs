import Control.Applicative ((<$>))
import Development.Shake
import Development.Shake.FilePath

main :: IO ()
main = shakeArgs options $ do
    want ["out/index.html"]
    "out/*.html" *> \out -> do
        contents <- map ("pandoc" </>) <$> getDirectoryFiles "pandoc" ["*"]
        need contents
        system' "pandoc" $ "-s" : "-o" : out : contents
  where
    options = shakeOptions
        { shakeVerbosity = Loud
        }
