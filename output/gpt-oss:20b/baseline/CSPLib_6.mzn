int: m;

array[1..m] of var int: a;
array[1..m*(m-1)/2] of var int: diff;

array[1..m*(m-1)/2] of int: iIdx = [i | i in 1..m, j in i+1..m];
array[1..m*(m-1)/2] of int: jIdx = [j | i in 1..m, j in i+1..m];

constraint a[1] = 0;
constraint forall(i in 1..m-1)(a[i] < a[i+1]);

constraint forall(k in 1..m*(m-1)/2)(diff[k] = a[jIdx[k]] - a[iIdx[k]]);

constraint all_different(diff);

constraint a[2] - a[1] < a[m] - a[m-1];

solve minimize a[m];

output [
  "length = ", show(a[m]), "\n",
  "marks = ", show(a), "\n"
];