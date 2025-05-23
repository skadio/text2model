% Parameters
int: r; % Number of rows in the grid
int: c; % Number of columns in the grid
array[1..r, 1..c] of int: puzzle; % Hidato puzzle grid

% Variables
% The solution grid, with the same dimensions as the puzzle grid
array[1..r, 1..c] of var 1..(r*c): solution;

% Constraints
% The solution grid should start with the same numbers as the puzzle grid
constraint forall(i in 1..r, j in 1..c) (
  puzzle[i,j] > 0 -> solution[i,j] = puzzle[i,j]
);

% Each number from 1 to r*c should appear exactly once in the solution grid
constraint forall(n in 1..(r*c)) (
  exactly(1, [ solution[i,j] | i in 1..r, j in 1..c ], n)
);

% Each number in the solution grid should be adjacent to the next number
constraint forall(i in 1..r, j in 1..c) (
  let { var set of int: adj = { solution[i+a,j+b] | a in -1..1, b in -1..1
                                where i+a >= 1 /\ i+a <= r /\ j+b >= 1 /\ j+b <= c /\ (a != 0 \/ b != 0) } } in
  (solution[i,j] < r*c) -> (solution[i,j]+1 in adj)
);

% Objective
% There is no objective for this problem, we just want to find a feasible solution
solve satisfy;