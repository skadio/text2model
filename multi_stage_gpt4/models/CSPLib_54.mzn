% Parameters
int: n; % Size of the chessboard and the number of queens to be placed

% Variables
array[1..n] of var 1..n: queens; % Array representing the position of each queen on the chessboard

% Constraints

% Each queen must be in a different row
constraint alldifferent(queens);

% No two queens are on the same diagonal
constraint forall(i in 1..n, j in i+1..n) (
  abs(queens[i] - queens[j]) != abs(i - j)
);

% Objective
solve satisfy;