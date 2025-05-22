% Parameters
int: height; % Height of the board
int: width; % Width of the board
int: maxship; % Maximal length of a ship
array[1..width, 1..height] of int: hint; % Initial board configuration with hints and ship information
array[1..width] of int: rowsum; % Sums for each row
array[1..height] of int: colsum; % Sums for each column
array[1..maxship] of int: ship; % Number of each type of ship

% Variables
array[1..width, 1..height] of var 0..1: board; % The board configuration

% Constraints
% The sum of each row and column should match the given rowsum and colsum
constraint forall(i in 1..width) (sum(j in 1..height) (board[i,j]) = rowsum[i]);
constraint forall(j in 1..height) (sum(i in 1..width) (board[i,j]) = colsum[j]);

% The number of each type of ship should match the given ship
constraint forall(k in 1..maxship) (
    sum(i in 1..width, j in 1..height) (
        bool2int(
            forall(dx in 0..k-1) (
                if i+dx <= width then board[i+dx,j] = 1 else true endif
            ) /\ 
            forall(dy in 0..k-1) (
                if j+dy <= height then board[i,j+dy] = 1 else true endif
            )
        )
    ) = ship[k]
);

% Ships cannot be adjacent to each other or diagonally connecting
constraint forall(i in 1..width, j in 1..height) (
    if board[i,j] = 1 then
        forall(dx in -1..1, dy in -1..1) (
            if i+dx >= 1 /\ i+dx <= width /\ j+dy >= 1 /\ j+dy <= height then
                board[i+dx,j+dy] = 0
            else
                true
            endif
        )
    else
        true
    endif
);

% The initial board configuration should be respected
constraint forall(i in 1..width, j in 1..height) (
    if hint[i,j] != -1 then
        board[i,j] = hint[i,j]
    else
        true
    endif
);

% Objective
solve satisfy;