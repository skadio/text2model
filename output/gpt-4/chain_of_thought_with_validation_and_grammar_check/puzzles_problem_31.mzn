% Parameters
int: n; % Size of the grid
array[1..n, 1..n] of var -1..9: puzzle; % Fill-a-Pix puzzle grid

% Variables
array[1..n, 1..n] of var 0..1: painted; % 1 if the cell is painted, 0 otherwise

% Constraints
constraint forall(i in 1..n, j in 1..n) (
  if puzzle[i,j] >= 0 then
    let {
      set of int: rows = max(1, i-1)..min(n, i+1),
      set of int: cols = max(1, j-1)..min(n, j+1)
    } in
      sum([painted[r,c] | r in rows, c in cols]) = puzzle[i,j]
  endif
);

% Objective
solve satisfy;