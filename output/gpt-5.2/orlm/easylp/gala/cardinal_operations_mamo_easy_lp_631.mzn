include "globals.mzn";

% Data (embedded as requested)
array[1..4] of int: fatigue = [2, 3, 4, 5];
array[1..4] of int: ub = [60, 70, 80, 90];

% Decision variables: training hours for groups x1..x4 (integers)
array[1..4] of var 0..max(ub): x;
constraint forall(i in 1..4)(x[i] <= ub[i]);

% Constraints from the description
constraint x[1] + x[2] <= 100;
constraint x[3] + x[4] >= 50;
constraint 2 * x[1] - x[2] = 30;
constraint abs(x[4] - 2 * x[3]) <= 40; % equivalent to |x4/2 - x3| <= 20 with integers

% Objective: minimize total fatigue score
var int: total_fatigue = sum(i in 1..4)(fatigue[i] * x[i]);

solve minimize total_fatigue;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "Total fatigue = ", show(total_fatigue), "\n"
];