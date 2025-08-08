include "globals.mzn";

int: n;                     % number of rows
int: m;                     % number of columns
array[1..n, 1..m] of int: grid;  % the given grid

% One position chosen per row
array[1..n] of var 1..m: pos;

% Valid moves: stay in the same column or move one column left/right
constraint
    forall(i in 2..n) (
        abs(pos[i] - pos[i-1]) <= 1
    );

% Sum of the selected numbers
var int: maxSum = sum(i in 1..n) ( grid[i][pos[i]] );

solve maximize maxSum;

output [
    "Max Sum = ", show(maxSum), "\n",
    "Path    = ", show(pos), "\n"
];