% Parameters
int: n; % Number of rows in the grid (provided in .dzn)
int: m; % Number of columns in the grid (provided in .dzn)
array[1..n, 1..m] of int: grid; % Grid of scores/values, indexed by (row, col)

% Variables
array[1..n] of var 1..m: path_col; % Chosen column index in each row (the path)
var int: total_sum; % Sum of selected grid values along the path
var int: max_sum;   % Objective value (linked to total_sum)

% Constraints
% Path continuity: from row r to r+1, column can stay, move left, or move right
constraint
  forall(r in 1..n-1) (
    abs(path_col[r+1] - path_col[r]) <= 1
  );

% Define the total sum as the sum of grid values along the chosen path
constraint
  total_sum = sum(r in 1..n) ( grid[r, path_col[r]] );

% Link max_sum to the achieved total_sum
constraint
  max_sum = total_sum;

% Objective
solve maximize max_sum;