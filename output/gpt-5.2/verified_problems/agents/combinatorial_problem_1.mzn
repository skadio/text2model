% Parameters
int: n;                               % Number of items
set of int: ITEMS = 1..n;             % Index set of items

array[ITEMS] of int: a;               % Value of each item

int: k;                               % Number of groups
set of int: GROUPS = 1..k;            % Index set of groups

% Useful derived bounds (computed from input)
int: total_value = sum(i in ITEMS)(a[i]);     % Sum of all item values
int: max_item_value = max(i in ITEMS)(a[i]);  % Maximum single item value

% Variables
array[ITEMS] of var GROUPS: group_of_item;          % Assigned group for each item (1..k)
array[GROUPS] of var 0..total_value: group_sum;     % Sum of values in each group
var max_item_value..total_value: max_group_sum;     % Maximum sum over all groups (objective value)

% Constraints

% Link item-to-group assignments with group sums
constraint
  forall(g in GROUPS) (
    group_sum[g] = sum(i in ITEMS)(a[i] * bool2int(group_of_item[i] == g))
  );

% Define max_group_sum as the maximum of all group sums
constraint
  max_group_sum = max(g in GROUPS)(group_sum[g]);

% (Optional symmetry breaking) Order group sums non-increasing to reduce equivalent solutions
constraint
  forall(g in 1..k-1) (
    group_sum[g] >= group_sum[g+1]
  );

% Objective
solve minimize max_group_sum;