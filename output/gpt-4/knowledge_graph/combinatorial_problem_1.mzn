% Parameters
int: n; % Number of items
array[1..n] of int: a; % Values of the items
int: k; % Number of groups

% Variables
array[1..n, 1..k] of var 0..1: x; % Binary variable indicating if item i is in group j
array[1..k] of var int: group_sum; % Sum of values in each group

% Constraints
constraint forall(i in 1..n)(sum(j in 1..k)(x[i,j]) = 1); % Each item is in exactly one group
constraint forall(j in 1..k)(group_sum[j] = sum(i in 1..n)(a[i]*x[i,j])); % The sum of values in each group is correct

% Objective
var int: max_group_sum; % Maximum sum of values in any group
constraint max_group_sum = max(j in 1..k)(group_sum[j]); % The maximum sum is the maximum of the group sums
solve minimize max_group_sum; % Minimize the maximum sum

% Output
output [ "Max group sum: ", show(max_group_sum), "\n" ] ++
[ if fix(x[i,j]) = 1 then "Item " ++ show(i) ++ " in group " ++ show(j) ++ "\n" else "" endif | i in 1..n, j in 1..k ];