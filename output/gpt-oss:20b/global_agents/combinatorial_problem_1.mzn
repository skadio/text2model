include "globals.mzn";

int: n;                         % number of items
array[1..n] of int: a;          % values of the items
int: k;                         % number of groups

% --- Variables ----------------------------------------------------
array[1..n] of var 1..k: assign;          % group of each item

array[1..k] of var int: groupSum;        % sum of values in each group
var int: maxSum;                         % maximum group sum

% --- Constraints --------------------------------------------------
% each group's sum is the sum of the values of items assigned to it
constraint
  forall(j in 1..k) (
    groupSum[j] = sum(i in 1..n)( ite(assign[i] == j, a[i], 0) )
  );

% maxSum is the maximum of all group sums
constraint
  maxSum = max(groupSum);

% --- Objective ----------------------------------------------------
solve minimize maxSum;

% --- Output -------------------------------------------------------
output [
  "Maximum sum among groups: ", show(maxSum), "\n",
  "Group sums: ", show(groupSum), "\n",
  "Item assignments (1..", show(k), "): ", show(assign), "\n"
];