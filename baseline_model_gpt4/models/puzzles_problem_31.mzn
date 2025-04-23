% Size of the grid
int: n;

% Fill-a-Pix puzzle grid
array[1..n, 1..n] of var 0..n: puzzle;

% Decision variable: whether a cell is painted or not
array[1..n, 1..n] of var 0..1: painted;

% Constraint: For each cell with a clue, the number of painted cells around it (including itself) should be equal to the clue
constraint forall(i in 1..n, j in 1..n) (
  if puzzle[i,j] > 0 then
    let {
      % Get the range of cells around the current cell
      set of int: rows = max(1, i-1)..min(n, i+1),
      set of int: cols = max(1, j-1)..min(n, j+1)
    } in
      % The sum of painted cells around the current cell (including itself) should be equal to the clue
      sum([painted[r,c] | r in rows, c in cols]) = puzzle[i,j]
  else
    true
  endif
);

% Objective: No objective, just find a feasible solution
solve satisfy;