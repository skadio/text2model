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

% The initial hints should be respected
constraint forall(i in 1..width, j in 1..height) (hint[i,j] = -1 \/ board[i,j] = hint[i,j]);

% The ships cannot be adjacent to each other or diagonally connecting
constraint forall(i in 1..width, j in 1..height) (
    if board[i,j] = 1 then
        forall(dx in -1..1, dy in -1..1) (
            if i+dx > 0 /\ i+dx <= width /\ j+dy > 0 /\ j+dy <= height then
                board[i+dx,j+dy] = 0
            endif
        )
    endif
);

% The number of each type of ship should match the given ship array
constraint forall(s in 1..maxship) (
    sum(i in 1..width, j in 1..height) (
        if board[i,j] = 1 then
            let {
                var bool: horizontal = forall(dx in 1..s-1) (i+dx <= width -> board[i+dx,j] = 1),
                var bool: vertical = forall(dy in 1..s-1) (j+dy <= height -> board[i,j+dy] = 1)
            } in
                (horizontal \/ vertical) /\ forall(dx in s..width-i) (i+dx <= width -> board[i+dx,j] = 0) /\ forall(dy in s..height-j) (j+dy <= height -> board[i,j+dy] = 0)
        else
            false
        endif
    ) = ship[s]
);

% Objective
solve satisfy;