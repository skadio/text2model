% Parameters
int: height; % Height of the board
int: width; % Width of the board
int: maxship; % Maximal length of a ship
array[1..width, 1..height] of int: hint; % Initial board configuration with hints and ship information
array[1..width] of int: rowsum; % Sums for each row
array[1..height] of int: colsum; % Sums for each column
array[1..maxship] of int: ship; % Number of each type of ship

% Variables
% The board configuration, where 0 represents water, 1 represents a ship, and -1 represents an unknown square
array[1..width, 1..height] of var 0..1: board;

% Constraints

% Constraint 1: The board configuration must match the initial hints
constraint forall(i in 1..width, j in 1..height) (
  if hint[i,j] != -1 then
    board[i,j] = hint[i,j]
  endif
);

% Constraint 2: The sum of each row must match the given row sum
constraint forall(i in 1..width) (
  sum(j in 1..height) (board[i,j]) = rowsum[i]
);

% Constraint 3: The sum of each column must match the given column sum
constraint forall(j in 1..height) (
  sum(i in 1..width) (board[i,j]) = colsum[j]
);

% Constraint 4: The number of each type of ship must match the given ship count
constraint forall(k in 1..maxship) (
  sum(i in 1..width, j in 1..height) (
    if i+k-1 <= width /\ forall(l in 0..k-1) (board[i+l,j] = 1) /\ 
       (i = 1 \/ board[i-1,j] = 0) /\ (i+k > width \/ board[i+k,j] = 0)
    then 1 else 0 endif
  ) +
  sum(i in 1..width, j in 1..height) (
    if j+k-1 <= height /\ forall(l in 0..k-1) (board[i,j+l] = 1) /\ 
       (j = 1 \/ board[i,j-1] = 0) /\ (j+k > height \/ board[i,j+k] = 0)
    then 1 else 0 endif
  ) = 2*ship[k]
);

% Constraint 5: Ships cannot be adjacent to each other or diagonally connecting
constraint forall(i in 1..width, j in 1..height) (
  if board[i,j] = 1 then
    forall(dx in -1..1, dy in -1..1) (
      if i+dx >= 1 /\ i+dx <= width /\ j+dy >= 1 /\ j+dy <= height /\ (dx != 0 \/ dy != 0) then
        board[i+dx,j+dy] != 1
      endif
    )
  endif
);

% Objective
solve satisfy;