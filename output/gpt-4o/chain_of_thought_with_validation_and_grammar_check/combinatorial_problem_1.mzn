% Parameters
int: n;
array[1..n] of int: a;
int: k;

set of int: ITEMS  = 1..n;
set of int: GROUPS = 1..k;

int: total_value = sum(i in ITEMS)(a[i]);

% Variables
array[ITEMS]  of var GROUPS: assign;                 % assign[i] = group of item i
array[GROUPS] of var 0..total_value: group_sum;      % total value of each group
var 0..total_value: max_group_sum;                   % value to minimise

% Constraints
constraint
  forall(g in GROUPS)(
    group_sum[g] = sum(i in ITEMS)( a[i] * bool2int(assign[i] == g) )
  );

constraint
  forall(g in GROUPS)(
    max_group_sum >= group_sum[g]
  );

% Objective
solve minimize max_group_sum;