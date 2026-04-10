% Resource allocation optimization (all data embedded)

% Decision variables (integer allocations with given upper bounds)
var 0..300: x1;
var 0..500: x2;
var 0..2000: x3;
var 0..30: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + 3*x3 >= 2000;

% "difference ... must not exceed" interpreted as absolute difference constraint
% x2 - 0.5*x4 <= 500  ==>  2*x2 - x4 <= 1000
% and -(x2 - 0.5*x4) <= 500  ==>  -2*x2 + x4 <= 1000
constraint 2*x2 - x4 <= 1000;
constraint -2*x2 + x4 <= 1000;

% |x1 - (x2 + x3)| <= 70
constraint x1 - (x2 + x3) <= 70;
constraint (x2 + x3) - x1 <= 70;

% Objective: minimize total cost
var int: total_cost = 4*x1 + 3*x2 + 5*x3 + 6*x4;
solve minimize total_cost;

% Output minimum total cost rounded to three decimal places
output [
  "minimum_total_cost = ",
  show( (round(1000.0 * int2float(total_cost))) / 1000.0 ),
  "\n",
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n"
];