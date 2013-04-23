import Control.Applicative ((<$>))
import Development.Shake
import Development.Shake.FilePath

main :: IO ()
main = shakeArgs options $ do
    want [ "out/index.html"
         , "out/js/impress.js"
         , "out/css/impress.css"
         ]
    "out/*.html" *> \out -> do
        contents <- map ("pandoc" </>) <$> getDirectoryFiles "pandoc" ["*"]
        after    <- map ("html" </>) <$> getDirectoryFiles "html" ["*after.html"]
        header   <- map ("html" </>) <$> getDirectoryFiles "html" ["*header.html"]
        need contents
        need after
        need header
        let afterArg = concatMap (\x -> ["-A", x]) after
        let headerArg = concatMap (\x -> ["-H", x]) header
        system' "pandoc" $ "-s" : "--section-divs" : "-o" : out : headerArg ++ afterArg ++ contents
    "out/css/*.css" *> \out -> do
        let source = replaceDirectory out "css"
        need [source]
        copyFile' source out
    "out//impress.js" *> \out -> do
        let source = "impress.js/js/impress.js"
        need [source]
        copyFile' source $ out
  where
    options = shakeOptions
        { shakeVerbosity = Loud
        }
