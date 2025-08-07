include "globals.mzn";

int: n;                     % Number of items
array[1..n] of int: a;     % Values of the items
int: k;                     % Number of groups

/* Variables */
array[1..n] of var 1..k: group;  % Group assignment for each item
array[1..k] of var 0..sum(a): group_sum;  % Sum of values in each group
var 0..sum(a): max_group_sum;  % Maximum sum among all groups

/* Constraints */
constraint 
    % Calculate the sum for each group based on item assignments
    forall(j in 1..k) (
        group_sum[j] = sum(i in 1..n (if group[i] = j then a[i] else 0 endif))
    );

constraint 
    % The maximum group sum should be equal to the maximum of the group sums
    max_group_sum = max(group_sum);

/* Solve & output */
solve minimize max_group_sum;
output [ "Maximum group sum = ", show(max_group_sum), "\n" ];