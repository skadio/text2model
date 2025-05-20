% Parameters
int: n; % Size of the chessboard and the number of queens to be placed

% Variables
array[1..n] of var 1..n: queens; % Array representing the position of each queen on the chessboard

% Constraints
include "alldifferent.mzn";
constraint alldifferent(queens); % All queens are in different rows
constraint forall(i in 1..n)(forall(j in i+1..n)(abs(queens[i]-queens[j]) != abs(i-j))); % No two queens are in the same diagonal

% Objective
solve satisfy; % The objective is to find a solution that satisfies all constraints