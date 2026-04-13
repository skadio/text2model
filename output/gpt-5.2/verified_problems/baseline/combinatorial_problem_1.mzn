int: n;
array[1..n] of int: a;
int: k;

array[1..n] of var 1..k: g;

array[1..k] of var int: sumg;
constraint forall(j in 1..k)(
  sumg[j] = sum(i in 1..n)(a[i] * bool2int(g[i] = j))
);

var int: maxsum;
constraint maxsum = max(j in 1..k)(sumg[j]);

solve minimize maxsum;

output [
  "maxsum = ", show(maxsum), ";\n",
  "sumg = ", show(sumg), ";\n",
  "g = ", show(g), ";\n"
];