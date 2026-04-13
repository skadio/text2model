int: C;
int: K;
array[1..K] of int: Value;
array[1..K] of int: Size;

array[1..K] of var 0..1: x;

constraint K > 0;
constraint sum(k in 1..K)(Size[k] * x[k]) <= C;

solve maximize sum(k in 1..K)(Value[k] * x[k]);

output [
  "x = ", show(x), "\n",
  "total_value = ", show(sum(k in 1..K)(Value[k] * x[k])), "\n",
  "total_size = ", show(sum(k in 1..K)(Size[k] * x[k])), "\n"
];