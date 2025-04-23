% Parameters
int: n; % Size of the grid
array[1..n, 1..n] of var 0..9: puzzle; % Fill-a-Pix puzzle grid

% Variables
array[1..n, 1..n] of var 0..1: painted; % 1 if the cell is painted, 0 otherwise

% Constraints
constraint forall(i in 1..n, j in 1..n) (
  if puzzle[i,j] != 0 then
    sum([painted[i+di,j+dj] | di in -1..1, dj in -1..1 where i+di > 0 /\ i+di <= n /\ j+dj > 0 /\ j+dj <= n]) = puzzle[i,j]
  else
    true
  endif
);

% Objective
solve satisfy;