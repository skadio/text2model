include "globals.mzn";

% Input data
int: n;
array[1..n] of int: a;
int: k;

% Decision: group assignment for each item
array[1..n] of var 1..k: g;

% Sum of each group and the maximum group sum
array[1..k] of var int: s;
var int: maxSum;

% Compute group sums
constraint forall(j in 1..k) (
  s[j] = sum(i in 1..n)( a[i] * bool2int(g[i] = j) )
);

% Define the maximum sum
constraint maxSum = max(j in 1..k)(s[j]);

% Symmetry breaking: enforce non-increasing group sums
constraint forall(j in 1..k-1)( s[j] >= s[j+1] );

solve minimize maxSum;

output [
  "maxSum = ", show(maxSum), ";\n",
  "s = ", show(s), ";\n",
  "g = ", show(g), ";\n"
];