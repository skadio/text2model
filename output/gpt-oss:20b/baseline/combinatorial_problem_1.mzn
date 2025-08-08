int: n;
array[1..n] of int: a;
int: k;

array[1..n] of var 1..k: group;

array[1..k] of var int: sum_g;

var int: max_sum;

constraint
  forall(g in 1..k) (
    sum_g[g] = sum(i in 1..n)(a[i] * bool2int(group[i] == g))
  );

constraint
  max_sum = max(sum_g);

solve minimize max_sum;

output [
  "Max sum: ", show(max_sum), "\n",
  "Group assignments: ", show(group), "\n",
  "Group sums: ", show(sum_g), "\n"
];