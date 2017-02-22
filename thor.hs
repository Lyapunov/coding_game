import System.IO
import Control.Monad

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    
    -- Auto-generated code below aims at helping you parse
    -- the standard input according to the problem statement.
    -- ---
    -- Hint: You can use the debug stream to print initialTX and initialTY, if Thor seems not follow your orders.
    
    input_line <- getLine
    let input = words input_line
    let lightx = read (input!!0) :: Int -- the X position of the light of power
    let lighty = read (input!!1) :: Int -- the Y position of the light of power
    let initialtx = read (input!!2) :: Int -- Thor's starting X position
    let initialty = read (input!!3) :: Int -- Thor's starting Y position
    loop lightx lighty initialtx initialty 
    
ververdict :: Int -> Int -> String
ververdict ly py = if ly > py then "S" else if ly < py then "N" else ""
   
horverdict :: Int -> Int -> String
horverdict lx px = if lx > px then "E" else if lx < px then "W" else ""
 
move :: Int -> Int -> Int
move lx px = if lx > px
             then px+1
             else if lx < px 
                  then px -1
                  else px
 
loop :: Int -> Int-> Int-> Int -> IO ()
loop lightx lighty posx posy = do
    input_line <- getLine
    let remainingturns = read input_line :: Int -- The remaining amount of turns Thor can move. Do not remove this line.
    
--     hPutStrLn stderr (show lightx)
--     hPutStrLn stderr (show lighty)
--    hPutStrLn stderr (show posx)
--    hPutStrLn stderr (show posy)
    
    -- A single line providing the move to be made: N NE E SE S SW W or NW
    putStrLn( (ververdict lighty posy) ++ (horverdict lightx posx) )
    
    let mx = move lightx posx
    let my = move lighty posy
    
    loop lightx lighty mx my
