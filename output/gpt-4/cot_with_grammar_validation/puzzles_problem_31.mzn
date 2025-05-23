% Parameters
int: n; % Size of the grid
array[1..n, 1..n] of var -1..9: puzzle; % Fill-a-Pix puzzle grid

% Variables
array[1..n, 1..n] of var 0..1: painted; % 1 if the cell is painted, 0 otherwise

% Constraints
constraint forall(i in 1..n, j in 1..n) (
  if puzzle[i,j] >= 0 then
    let {
      % Define the range of cells around the clue
      int: min_row = max(1, i-1),
      int: max_row = min(n, i+1),
      int: min_col = max(1, j-1),
      int: max_col = min(n, j+1)
    } in
      % The number of painted cells around the clue (including the clue cell) should match the clue
      sum([painted[k,l] | k in min_row..max_row, l in min_col..max_col]) = puzzle[i,j]
  else
    true
  endif
);

% Objective
solve satisfy;