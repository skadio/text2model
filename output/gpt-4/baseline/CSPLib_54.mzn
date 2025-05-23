include "globals.mzn";

% Size of the chessboard and the number of queens to be placed
int: n;

% Array representing the position of each queen on the chessboard
array[1..n] of var 1..n: queens;

% No two queens are in the same row
constraint alldifferent(queens);

% No two queens are in the same diagonal
constraint forall(i in 1..n)(forall(j in i+1..n)(abs(queens[i]-queens[j]) != abs(i-j)));

% Find a solution
solve satisfy;