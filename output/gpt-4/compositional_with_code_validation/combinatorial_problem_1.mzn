% Parameters
int: n; % Number of items in the group
array[1..n] of int: a; % Values of the items in the group
int: k; % Number of groups to split into

% Variables
var int: max_sum; % Maximum sum amongst all groups
array[1..n] of var 1..k: group_assignment; % Group assignment for each item

% Constraints

% Each group must have at least one item
constraint forall(g in 1..k) (
  exists(i in 1..n) (group_assignment[i] = g)
);

% The sum of the values in each group should be less than or equal to max_sum
constraint forall(g in 1..k) (
  sum(i in 1..n where group_assignment[i] = g) (a[i]) <= max_sum
);

% The sum of the values in the group with the highest sum should be equal to max_sum
constraint max_sum = max(g in 1..k) (
  sum(i in 1..n where group_assignment[i] = g) (a[i])
);

% Objective
solve minimize max_sum;