include "globals.mzn";

% Parameters
int: height; % Height of the board
int: width; % Width of the board
int: maxship; % Maximal length of a ship
array[1..height, 1..width] of int: hint; % Initial board configuration with hints and ship information
array[1..height] of int: rowsum; % Sums for each row
array[1..width] of int: colsum; % Sums for each column
array[1..maxship] of int: ship; % Number of each type of ship

% Variables
array[1..height, 1..width] of var 0..1: board; % The board configuration
array[1..maxship] of var 0..max(ship): ship_count; % The count of each type of ship

% Constraints
constraint forall(i in 1..height)(sum(j in 1..width)(board[i,j]) = rowsum[i]);
constraint forall(j in 1..width)(sum(i in 1..height)(board[i,j]) = colsum[j]);
constraint forall(i in 1..height, j in 1..width)(hint[i,j] = -1 \/ board[i,j] = hint[i,j]);
constraint forall(i in 1..height, j in 1..width)(if board[i,j] = 1 then forall(dx in -1..1, dy in -1..1)(i+dx > 0 /\ i+dx <= height /\ j+dy > 0 /\ j+dy <= width -> board[i+dx,j+dy] = 0) endif);
constraint forall(i in 1..height, j in 1..width)(if board[i,j] = 1 then exists(l in 1..maxship)(forall(dx in 0..l-1)(i+dx > 0 /\ i+dx <= height -> board[i+dx,j] = 1) /\ (i+l > height \/ board[i+l,j] = 0)) endif);
constraint forall(i in 1..height, j in 1..width)(if board[i,j] = 1 then exists(l in 1..maxship)(forall(dy in 0..l-1)(j+dy > 0 /\ j+dy <= width -> board[i,j+dy] = 1) /\ (j+l > width \/ board[i,j+l] = 0)) endif);
constraint forall(l in 1..maxship)(ship_count[l] = ship[l]);

% Solve
solve satisfy;