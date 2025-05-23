% Parameters
int: n; % Number of items in the group
array[1..n] of int: a; % Values of the items in the group
int: k; % Number of groups to split into

% Variables
var int: max_sum; % Maximum sum amongst all groups
array[1..n] of var 1..k: group; % Group assignment for each item

% Constraints
constraint forall(i in 1..k)(sum(j in 1..n)(a[j]*(group[j] = i)) <= max_sum);

% Objective
solve minimize max_sum;