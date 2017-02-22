import System.IO
import Control.Monad
import Data.List

conwaySequence :: Int -> Int -> [Int]
conwaySequence 1 basis = [basis]
conwaySequence n basis = go pt [] ph 1
  where go []  res z count = res ++ [count, z]
        go (x:xs) res z count = if x == z then go xs res z (count+1)
                                else go xs (res ++ [count, z]) x 1
        prev = (conwaySequence (n-1) basis)
        ph = head prev
        pt = tail prev

-- tricky dicky
fff :: [Int] -> [String]
fff = map show

ggg :: [Int] -> String
ggg = concat . intersperse " " . fff

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- Auto-generated code below aims at helping you parse
    -- the standard input according to the problem statement.
    
    input_line <- getLine
    let r = read input_line :: Int
    input_line <- getLine
    let l = read input_line :: Int
    
    -- hPutStrLn stderr "Debug messages..."
    
    -- Write answer to stdout
    putStrLn ( ggg(conwaySequence l r) )
    return ()
