% Parameters
int: r; % Number of rows in the grid
int: c; % Number of columns in the grid
array[1..r, 1..c] of int: puzzle; % Hidato puzzle grid

% Variables
% No additional variables are needed for this problem as the puzzle grid itself is the variable that needs to be solved.

% Constraints

% The puzzle grid should contain all numbers from 1 to r*c
constraint forall(i in 1..r*c) (
    exists(ij in { (i,j) | i in 1..r, j in 1..c }) ( puzzle[ij[1], ij[2]] = i )
);

% Each cell in the puzzle grid should be adjacent to the cell with the next number
constraint forall(i in 1..r, j in 1..c) (
    if puzzle[i,j] > 0 /\ puzzle[i,j] < r*c then
        let {
            % Define the set of possible adjacent cells
            set of int: adj_i = max(1, i-1)..min(r, i+1),
            set of int: adj_j = max(1, j-1)..min(c, j+1),
            % Define the set of all adjacent cells
            set of (int, int): adj_cells = { (ai, aj) | ai in adj_i, aj in adj_j, ai != i \/ aj != j }
        } in
            % There should exist an adjacent cell with the next number
            exists(cell in adj_cells) ( puzzle[cell[1], cell[2]] = puzzle[i,j] + 1 )
    else
        true
    endif
);

% The start and end numbers should be 1 and r*c respectively
constraint exists(ij in { (i,j) | i in 1..r, j in 1..c }) ( puzzle[ij[1], ij[2]] = 1 );
constraint exists(ij in { (i,j) | i in 1..r, j in 1..c }) ( puzzle[ij[1], ij[2]] = r*c );

% Objective
% Since this is a puzzle, there is no objective to minimize or maximize. 
% The goal is to find a feasible solution that satisfies all the constraints.
solve satisfy;