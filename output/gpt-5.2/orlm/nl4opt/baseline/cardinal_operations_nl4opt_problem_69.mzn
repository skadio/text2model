int: wide_capacity = 25;
int: narrow_capacity = 15;

int: demand = 900;

var int: W; % number of wide pipes
var int: N; % number of narrow pipes

constraint W >= 5;
constraint 3 * W <= N; % wide pipes at most a third the number of narrow pipes
constraint wide_capacity * W + narrow_capacity * N >= demand;

solve minimize W + N;

output [
  "Wide pipes (W) = ", show(W), "\n",
  "Narrow pipes (N) = ", show(N), "\n",
  "Total pipes = ", show(W + N), "\n",
  "Total capacity = ", show(wide_capacity * W + narrow_capacity * N), " units/min\n"
];