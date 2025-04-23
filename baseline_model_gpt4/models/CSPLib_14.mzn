include "globals.mzn";

% Parameters
int: height; % Height of the board
int: width; % Width of the board
int: maxship; % Maximal length of a ship
array[1..width, 1..height] of int: hint; % Initial board configuration with hints and ship information
array[1..width] of int: rowsum; % Sums for each row
array[1..height] of int: colsum; % Sums for each column
array[1..maxship] of int: ship; % Number of each type of ship

% Variables
array[1..width, 1..height] of var 0..1: board; % The board

% Constraints
constraint forall(i in 1..width)(sum(j in 1..height)(board[i,j]) = rowsum[i]);
constraint forall(j in 1..height)(sum(i in 1..width)(board[i,j]) = colsum[j]);

% Ships cannot be adjacent to each other or diagonally connecting
constraint forall(i in 1..width, j in 1..height)(
  (board[i,j] = 1) -> 
  (forall(dx in -1..1, dy in -1..1)(
    (i+dx > 0 /\ i+dx <= width /\ j+dy > 0 /\ j+dy <= height) -> 
    (board[i+dx,j+dy] = 0)
  ))
);

% Ships of varying lengths
constraint forall(l in 1..maxship)(
  sum(i in 1..width-l+1, j in 1..height)(
    (forall(dx in 0..l-1)(board[i+dx,j] = 1)) /\ 
    ((i > 1 -> board[i-1,j] = 0) /\ (i+l <= width -> board[i+l,j] = 0))
  ) = ship[l]
);

% Initial board configuration with hints and ship information
constraint forall(i in 1..width, j in 1..height)(
  (hint[i,j] = 1) -> (board[i,j] = 1)
);

% Solve
solve satisfy;