type Position = (Int, Int)
data Color = W | B deriving (Eq, Show)
data Peg = Peg Position Color deriving (Eq, Show)
data Move = M Position deriving (Eq, Show)
type Board = [Peg]
data State = S Move Board deriving (Eq, Show)

board :: Board
board = [
    Peg (-3, -1) B, Peg (-3, 0) B, Peg (-3, 1) B,
    Peg (-2, -1) B, Peg (-2, 0) B, Peg (-2, 1) B,
    Peg (-1, -3) B, Peg (-1, -2) B, Peg (-1, -1) B,
    Peg (-1, 0) B, Peg (-1, 1) B, Peg (-1, 2) B,
    Peg (-1, 3) B, Peg (0, -3) B, Peg (0, -2) B,
    Peg (0, -1) B, Peg (0, 0) B, Peg (0, 1) B,
    Peg (0, 2) B, Peg (0, 3) B, Peg (1, -3) B,
    Peg (1, -2) B, Peg (1, -1) B, Peg (1, 0) B,
    Peg (1, 1) B, Peg (1, 2) B, Peg (1, 3) B,
    Peg (2, -1) B, Peg (2, 0) B, Peg (2, 1) B,
    Peg (3, -1) B, Peg (3, 0) B, Peg (3, 1) B
    ]

createBoard :: Position -> Board
createBoard pos = 
    if elem (Peg pos B) board 
    then helper pos board 
    else error "Program error: The position is not valid."

helper :: Position -> Board -> Board
helper _ [] = []
helper (x,y) (Peg (b,c) d : t) =
    if pos == (b,c) 
    then Peg (b,c) W : t 
    else Peg (b,c) d : helper pos t 
	where pos=(x,y)

	
checkpegColor (x,y) board1
	| elem (Peg (x,y) W) board1 ==True =True
	| otherwise= False

isValidMove :: Move -> Board -> Bool
isValidMove (M (a, b)) board1 
	|checkpegColor ((a-1),b) board1==True=True
	|checkpegColor ((a+1),b) board1 ==True=True
	|checkpegColor (a,(b-1)) board1==True=True
	|checkpegColor (a,(b+1)) board1==True=True
	|otherwise = False


isGoal :: Board -> Bool
isGoal [] = True
isGoal (Peg _ c : t) 
    | c == W = isGoal t
    | otherwise = False

showPossibleNextStates :: Board -> [State]
showPossibleNextStates board2 
    | isGoal board2 ==True= error "No Possible States Exist."
    | otherwise = helper3 (helper2 board2) board2 board2

helper2 :: [Peg] -> [Peg]
helper2 [] = []
helper2 (Peg (b,c) d : t) = if d == B then Peg (b,c) d : helper2 t else helper2 t
 
helper3 :: [Peg] -> Board -> Board -> [State]
helper3 [] _ _ = []
helper3 (Peg (b,c) d : t) board board1
    | d==B && isValidMove (M (b, c)) board1==True = (S (M (b,c)) (helper (b,c) board)) : helper3 t board1 board1
    | otherwise = helper3 t board1 board1
