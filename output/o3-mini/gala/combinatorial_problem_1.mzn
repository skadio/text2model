include "globals.mzn";

/* Parameters (provided in the .dzn file) */
int: n;               % number of items
int: k;               % number of groups to split into
array[1..n] of int: a;  % values of the items

/* Decision variable: assign each item to one of the k groups */
array[1..n] of var 1..k: group;

/* Compute the sum of values for each group */
array[1..k] of var int: groupSum;
constraint forall(g in 1..k)(
    groupSum[g] = sum(i in 1..n)( if group[i] = g then a[i] else 0 endif )
);

/* The maximum sum amongst all groups */
var int: maxSum;
constraint maxSum = max(g in 1..k)(groupSum[g]);

/* Objective: minimize the maximum group sum */
solve minimize maxSum;

/* Output the result */
output [
  "Maximum group sum = ", show(maxSum), "\n", 
  "Group assignments: ", show(group), "\n",
  "Group sums: ", show(groupSum), "\n"
];