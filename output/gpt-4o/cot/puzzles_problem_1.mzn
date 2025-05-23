% Parameters
int: n;
int: m;
array[1..n, 1..m] of int: grid;

% Variables
array[1..n] of var 1..m: path;        % column chosen in each row
var int: total_sum;                   % total value collected along the path

% Constraints
constraint
    forall(r in 1..n-1) (
        abs(path[r+1] - path[r]) <= 1     % move straight, down-left, or down-right
    );

constraint
    total_sum = sum(r in 1..n)( grid[r, path[r]] );   % accumulate the selected values

% Objective
solve maximize total_sum;