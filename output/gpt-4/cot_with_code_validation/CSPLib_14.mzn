% Parameters
int: height; % Height of the board
int: width; % Width of the board
int: maxship; % Maximal length of a ship
array[1..width, 1..height] of int: hint; % Initial board configuration with hints and ship information
array[1..width] of int: rowsum; % Sums for each row
array[1..height] of int: colsum; % Sums for each column
array[1..maxship] of int: ship; % Number of each type of ship

% Variables
% The board is represented as a 2D array of 0s and 1s, where 1 represents a ship and 0 represents water
array[1..width, 1..height] of var 0..1: board;

% Constraints
% The sum of each row and column must match the given row and column sums
constraint forall(i in 1..width) (sum(j in 1..height) (board[i,j]) = rowsum[i]);
constraint forall(j in 1..height) (sum(i in 1..width) (board[i,j]) = colsum[j]);

% The number of ships of each length must match the given ship counts
constraint forall(k in 1..maxship) (
    sum(i in 1..width, j in 1..height) (
        if k = 1 then
            % For ships of length 1, just count the number of 1s in the board
            board[i,j]
        else
            % For ships of length greater than 1, count the number of horizontal and vertical sequences of 1s of length k
            bool2int(i <= width - k + 1 /\ forall(l in 0..k-1) (board[i+l,j] = 1) /\ (i = 1 \/ board[i-1,j] = 0) /\ (i = width - k + 1 \/ board[i+k,j] = 0)) +
            bool2int(j <= height - k + 1 /\ forall(l in 0..k-1) (board[i,j+l] = 1) /\ (j = 1 \/ board[i,j-1] = 0) /\ (j = height - k + 1 \/ board[i,j+k] = 0))
        endif
    ) = ship[k]
);

% Ships cannot be adjacent to each other or diagonally connecting
constraint forall(i in 1..width, j in 1..height) (
    if board[i,j] = 1 then
        % If there is a ship at (i,j), then there cannot be a ship at any of the 8 surrounding squares
        forall(di in -1..1, dj in -1..1) (
            if i + di >= 1 /\ i + di <= width /\ j + dj >= 1 /\ j + dj <= height /\ (di != 0 \/ dj != 0) then
                board[i+di,j+dj] = 0
            endif
        )
    endif
);

% The initial board configuration must be respected
constraint forall(i in 1..width, j in 1..height) (
    if hint[i,j] != -1 then
        board[i,j] = hint[i,j]
    endif
);

% Objective
% There is no objective for this problem, we just want to find a feasible solution
solve satisfy;