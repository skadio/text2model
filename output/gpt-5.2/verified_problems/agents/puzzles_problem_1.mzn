% Parameters
int: n; % Number of rows in the grid
int: m; % Number of columns in the grid
array[1..n, 1..m] of int: grid; % Grid values (input)

% Variables
array[1..n] of var 1..m: col; % col[r] = chosen column index in row r (path)
var int: total_sum; % Total sum of chosen grid values along the path
var int: max_sum; % Objective value (maximum achievable sum)

% Constraints
% Path adjacency constraints: each move from row r to r+1 is down-left, down, or down-right
constraint
  forall(r in 1..n-1) (
    abs(col[r+1] - col[r]) <= 1
  );

% Total sum definition: sum of the grid values selected by the path columns
constraint
  total_sum = sum(r in 1..n) ( grid[r, col[r]] );

% Link max_sum to the achieved total_sum (objective handled in solve)
constraint
  max_sum = total_sum;

% Objective
solve maximize max_sum;