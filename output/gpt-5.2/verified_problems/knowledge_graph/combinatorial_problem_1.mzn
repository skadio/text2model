int: n;
array[1..n] of int: a;
int: k;

array[1..n] of var 1..k: groupAssignment;

array[1..k] of var int: groupSum =
  [sum(i in 1..n)(a[i] * bool2int(groupAssignment[i] == g)) | g in 1..k];

var int: maxGroupSum = max(g in 1..k)(groupSum[g]);

constraint forall(g in 1..k)(groupSum[g] <= maxGroupSum);

solve minimize maxGroupSum;

output [
  "maxGroupSum=", show(maxGroupSum), "\n",
  "groupAssignment=", show(groupAssignment), "\n",
  "groupSum=", show(groupSum), "\n"
];