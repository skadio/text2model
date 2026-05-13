int: n;
int: m;
array[1..n, 1..m] of int: grid;

array[1..n] of var 1..m: path;
var int: max_sum;

constraint forall(i in 2..n) (
    abs(path[i] - path[i-1]) <= 1
);

constraint max_sum = sum(i in 1..n)(grid[i, path[i]]);

solve maximize max_sum;

output [
    "Maximum sum: ", show(max_sum), "\n",
    "Path indices: ", show(path), "\n"
];