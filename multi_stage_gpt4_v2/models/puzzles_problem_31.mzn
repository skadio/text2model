% Parameters
int: n; % Size of the grid (number of rows and columns)
array[1..n, 1..n] of string: puzzle; % Fill-a-Pix puzzle grid where X represents an unknown cell and a number represents a clue

% Variables
array[1..n, 1..n] of var 0..1: painted; % Binary variable indicating whether a cell is painted (1) or not (0)

% Constraints

% For each cell in the grid
forall(i in 1..n, j in 1..n) (
  % If the cell is a clue
  if puzzle[i,j] != "X" then
    % The number of painted cells around the clue (including the clue cell itself) should be equal to the clue value
    let {
      % Define the range of rows and columns to consider around the clue
      set of int: rows = max(1, i-1)..min(n, i+1),
      set of int: cols = max(1, j-1)..min(n, j+1)
    } in
    sum(r in rows, c in cols) (painted[r,c]) = to_int(puzzle[i,j])
  endif
);

% Objective
solve satisfy;