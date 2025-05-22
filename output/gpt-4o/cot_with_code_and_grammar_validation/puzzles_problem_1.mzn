% Parameters
int: n;
int: m;
array[1..n, 1..m] of int: grid;

% Variables
array[1..n] of var 1..m: col;     % selected column in each row
var int: totalSum;                % total value of the chosen path

% Constraints
constraint
  forall(i in 1..n-1)(
    col[i+1] >= col[i] - 1 /\ col[i+1] <= col[i] + 1
  );

constraint
  totalSum = sum(i in 1..n)( grid[i, col[i]] );

% Objective
solve maximize totalSum;

output [
  "Selected columns: ", show(col), "\n",
  "Maximum sum: ", show(totalSum), "\n"
];