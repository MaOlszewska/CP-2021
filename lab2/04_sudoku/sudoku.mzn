%%%%%%%%%%%
% REMINDER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There's something missing here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial state of the board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "cumulative.mzn";
array[int,int] of int: board;
set of int: PuzzleRange = index_set_1of2(board);
int: N = max(PuzzleRange);
int: S = floor(sqrt(N));
array[1..N, 1..N] of var 1..N: puzzle;

constraint assert(index_set_2of2(board) = PuzzleRange, "The board should be a square array"); 
constraint assert(S * S == N, "The board size should be a square of a natural number");
constraint assert(min(board) = 0, "The board should contain at least one empty space and no negative values");
constraint assert(max(board) <= N, "The board shouldn't contain values bigger than the board size");

%%%%%%%%%%% 
% VARIABLES  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You know... Use the 'puzzle' name from the output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - you know the sudoku rules
% - remember, that you have to preserve the initial state of the board  
% tips.
% - you can slice arrays like in python, e.g. board[1,1..3] 
%   is the first three elements of the first row of the board array
% - there are
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint forall(i,j in 1..N where board[i,j] != 0)(puzzle[i,j] = board[i,j]);
constraint forall(i in 1..N )(alldifferent(j in 1..N)(puzzle[j,i]));
constraint forall(i in 1..N)(alldifferent(j in 1..N)(puzzle[i,j]));
constraint forall(i,j in 0..S - 1 )(alldifferent(k,l in 1..S)(puzzle[i * S + k, j * S + l]));

solve satisfy;

%%%%%%%%%%%%%%%%%%%%
% OUTPUT EXAMPLE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - puzzle - 2d array of nxn variables
% - N - size of the board, equal S*S         
% - S - size of a single sector            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output [ show(puzzle[i,j]) ++ " " ++
  if j mod S == 0 then " " else "" endif ++ if j == N /\ i != N then
  if i mod S == 0 then "\n\n" else "\n" endif else "" endif
    | i,j in PuzzleRange ] ++ ["\n"];

