% Tourism packages optimization (all data embedded)

% Decision variables: number of each package to launch (integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Costs ($)
int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

% Resource caps (interpreting "resources required" as units = number launched)
constraint x1 + x2 <= 50;
constraint x3 + x4 <= 80;

% Quality/ratings constraints (use integer-scaled to avoid fractions)
% 0.6*x1 + 0.8*x2 >= 20  ->  6*x1 + 8*x2 >= 200
constraint 6*x1 + 8*x2 >= 200;

% 0.7*x3 + 0.9*x4 >= 30  ->  7*x3 + 9*x4 >= 300
constraint 7*x3 + 9*x4 >= 300;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];