% Parameters
int: n; % Size of the grid (number of rows and columns)
array[1..n, 1..n] of var -1..9: puzzle; % Fill-a-Pix puzzle grid where -1 represents an unknown cell and a number from 0 to 9 represents a clue

% Variables
array[1..n, 1..n] of var 0..1: painted; % Binary variable indicating whether a cell is painted (1) or not (0)

% Constraints

% For each cell in the grid
forall(i in 1..n, j in 1..n) (
  % If the cell is a clue
  if puzzle[i,j] >= 0 then
    % The number of painted cells in the 3x3 neighborhood (including the cell itself) should be equal to the clue
    let {
      % Define the range of the neighborhood
      set of int: rows = max(1, i-1)..min(n, i+1);
      set of int: cols = max(1, j-1)..min(n, j+1);
    } in
    sum(r in rows, c in cols) (painted[r,c]) = puzzle[i,j]
  endif
);

% For each cell in the grid
forall(i in 1..n, j in 1..n) (
  % If the cell is not a clue
  if puzzle[i,j] = -1 then
    % The cell should not be painted
    painted[i,j] = 0
  endif
);

% Objective
% As this is a satisfaction problem, there is no objective to minimize or maximize.
solve satisfy;