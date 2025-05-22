% Parameters
int: n;
array[1..n] of int: a;
int: k;

int: total_sum = sum(i in 1..n)(a[i]);

% Variables
array[1..n, 1..k] of var 0..1: x;                 % x[i,g] = 1 if item i is in group g
array[1..k] of var 0..total_sum: group_sum;       % sum of values in each group
var 0..total_sum: max_group_sum;                  % maximum group sum (to be minimized)

% Constraints
constraint
    forall(i in 1..n)(
        sum(g in 1..k)(x[i,g]) = 1                % each item assigned to exactly one group
    );

constraint
    forall(g in 1..k)(
        group_sum[g] = sum(i in 1..n)(a[i] * x[i,g])
    );

constraint
    forall(g in 1..k)(
        group_sum[g] <= max_group_sum             % max_group_sum is at least every group sum
    );

% Optional symmetry breaking (can improve search)
constraint
    forall(g in 1..k-1)(
        group_sum[g] <= group_sum[g+1]
    );

% Objective
solve minimize max_group_sum;