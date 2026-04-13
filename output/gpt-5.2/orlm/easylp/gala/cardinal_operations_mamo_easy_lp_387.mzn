% Tourism packages cost minimization (integer decision variables)

include "globals.mzn";

% Decision variables: number of each package to launch (integers, nonnegative)
var 0..50: x1;  % capped by x1+x2 <= 50
var 0..50: x2;
var 0..80: x3;  % capped by x3+x4 <= 80
var 0..80: x4;

% Resource caps
constraint x1 + x2 <= 50;
constraint x3 + x4 <= 80;

% Quality / rating requirements (interpreted as weighted sums)
constraint 0.6 * int2float(x1) + 0.8 * int2float(x2) >= 20.0;
constraint 0.7 * int2float(x3) + 0.9 * int2float(x4) >= 30.0;

% Objective: minimize total cost
var float: total_cost =
    100.0 * int2float(x1) +
    200.0 * int2float(x2) +
    300.0 * int2float(x3) +
    400.0 * int2float(x4);

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "total_cost_rounded=", show(round(total_cost)), "\n"
];