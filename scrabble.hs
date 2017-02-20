import System.IO
import Control.Monad
import Data.List

canBeComposedFrom :: String -> String -> Bool
canBeComposedFrom word letters = go (sort word) (sort letters)
   where go [] _  = True
         go _ []  = False
         go (x:xs) (y:ys) = if x == y then go xs ys
                                      else go (x:xs) ys
-- print ( canBeComposedFrom "which" "hicquwh"  ) => True
-- print ( canBeComposedFrom "hicquwh" "which"  ) => False

calculateLetterScore :: Char -> Int
calculateLetterScore letter = go letter letterset scoreset
   where go x (lh:ls) (sh:ss) = if elem x lh
                                then sh
                                else go x ls ss
         letterset = ["eaionrtlsu", "dg", "bcmp", "fhvwy", "k", "jx", "qz"]
         scoreset  = [1,2,3,4,5,8,10]

calculateWordScore :: String -> Int
calculateWordScore "" = 0
calculateWordScore (x:xs) = calculateLetterScore x + calculateWordScore xs

--  print ( calculateWordScore "banjo" ) => 14

findBestWord :: [String] -> String -> String
findBestWord wlist letters = go wlist "" 0
   where go []     wword wscore = wword
         go (x:xs) wword wscore =
            if canBeComposedFrom x letters && calculateWordScore x > wscore
            then go xs x (calculateWordScore x)
            else go xs wword wscore

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- Auto-generated code below aims at helping you parse
    -- the standard input according to the problem statement.
    
    input_line <- getLine
    let n = read input_line :: Int
    
    words <- replicateM (read input_line) getLine
    uletters <- getLine
    -- print words
   
    -- hPutStrLn stderr "Debug messages..."
    
    -- Write answer to stdout
    putStrLn (findBestWord words uletters)
