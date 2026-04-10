% Parameters
int: n;                           % Number of items
set of int: ITEMS = 1..n;         % Index set for items

array[ITEMS] of int: a;           % Value of each item

int: k;                           % Number of groups
set of int: GROUPS = 1..k;        % Index set for groups


% Variables
array[ITEMS] of var GROUPS: grp;  % Group assignment for each item (1..k)

array[GROUPS] of var int: sum_g;  % Sum of values in each group

var int: max_sum;                 % Maximum group sum (objective value)


% Constraints
% (1) Define each group's sum as the sum of item values assigned to it
constraint
  forall(g in GROUPS) (
    sum_g[g] = sum(i in ITEMS) (a[i] * bool2int(grp[i] == g))
  );

% (2) Define max_sum as the maximum of the group sums
constraint
  max_sum = max(g in GROUPS) (sum_g[g]);


% Objective
solve minimize max_sum;