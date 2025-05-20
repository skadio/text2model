include "globals.mzn";

% Number of items in the group
int: n;

% Values of the items in the group
array[1..n] of int: a;

% Number of groups to split into
int: k;

% Decision variables
array[1..n] of var 1..k: group;
array[1..k] of var int: group_sum;

% Constraints
constraint forall(i in 1..k)(group_sum[i] = sum(j in 1..n)(a[j]*(group[j] = i)));

% Objective
var int: max_sum = max(group_sum);
solve minimize max_sum;

% Output
output ["The maximum sum amongst all groups is: ", show(max_sum)];