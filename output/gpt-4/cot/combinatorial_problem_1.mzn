% Parameters
int: n; % Number of items in the group
array[1..n] of int: a; % Values of the items in the group
int: k; % Number of groups to split into

% Variables
array[1..n, 1..k] of var 0..1: x; % Binary variable indicating if item i is in group j
array[1..k] of var int: group_sum; % Sum of values in each group

% Constraints
% Each item must be in exactly one group
constraint forall(i in 1..n)(sum(j in 1..k)(x[i,j]) = 1);

% The sum of values in each group must be equal to the sum of the values of the items in that group
constraint forall(j in 1..k)(group_sum[j] = sum(i in 1..n)(a[i]*x[i,j]));

% Objective
% Minimize the maximum sum amongst all groups
solve minimize max(group_sum);