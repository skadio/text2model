% Parameters
int: r; % Number of rows in the grid
int: c; % Number of columns in the grid
array[1..r, 1..c] of int: puzzle; % Hidato puzzle grid

% Variables
array[1..r, 1..c] of var 1..(r*c): solution; % Solution grid

% Constraints
% The solution grid should match the initial puzzle grid for the filled cells
constraint forall(i in 1..r, j in 1..c) (
  if puzzle[i,j] > 0 then solution[i,j] = puzzle[i,j] endif
);

% Each number from 1 to r*c should appear exactly once in the solution grid
constraint forall(k in 1..(r*c)) (
  sum(i in 1..r, j in 1..c) (bool2int(solution[i,j] = k)) = 1
);

% Each number in the solution grid should be adjacent to the next number
constraint forall(i in 1..r, j in 1..c) (
  let { var set of int: adj = {solution[i+a,j+b] | a in -1..1, b in -1..1, i+a >= 1 /\ i+a <= r /\ j+b >= 1 /\ j+b <= c} } in
  if solution[i,j] < r*c then (solution[i,j] + 1) in adj endif
);

% Objective
% This is a satisfaction problem, so there is no objective to optimize
solve satisfy;