% Parameters
int: height; % Height of the board
int: width; % Width of the board
int: maxship; % Maximal length of a ship
array[1..width, 1..height] of int: hint; % Initial board configuration with hints and ship information
array[1..width] of int: rowsum; % Sums for each row
array[1..height] of int: colsum; % Sums for each column
array[1..maxship] of int: ship; % Number of each type of ship

% Variables
% The board is represented as a 2D array of integers, where 0 represents water, 1 represents a ship, and -1 represents an unknown square
array[1..width, 1..height] of var 0..1: board;

% Constraints

% Constraint 1: The sum of each row in the board should be equal to the corresponding rowsum
constraint forall(i in 1..width) (
  sum(j in 1..height) (board[i,j]) = rowsum[i]
);

% Constraint 2: The sum of each column in the board should be equal to the corresponding colsum
constraint forall(j in 1..height) (
  sum(i in 1..width) (board[i,j]) = colsum[j]
);

% Constraint 3: The number of each type of ship should be equal to the corresponding ship
constraint forall(k in 1..maxship) (
  sum(i in 1..width, j in 1..height) (bool2int(board[i,j] = 1)) = ship[k]
);

% Constraint 4: Ships cannot be adjacent to each other or diagonally connecting
constraint forall(i in 1..width, j in 1..height) (
  if board[i,j] = 1 then
    forall(dx in -1..1, dy in -1..1) (
      if i+dx > 0 /\ i+dx <= width /\ j+dy > 0 /\ j+dy <= height then
        board[i+dx,j+dy] = 0
      endif
    )
  endif
);

% Constraint 5: The initial board configuration with hints and ship information should be respected
constraint forall(i in 1..width, j in 1..height) (
  if hint[i,j] != -1 then
    board[i,j] = hint[i,j]
  endif
);

% Objective
% As this is a feasibility problem, there is no objective to minimize or maximize.
solve satisfy;