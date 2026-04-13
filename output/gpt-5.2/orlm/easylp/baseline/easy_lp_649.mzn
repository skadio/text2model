% Shipping allocation optimization (all data embedded)

int: cost1 = 5;
int: cost2 = 6;
int: cost3 = 7;
int: cost4 = 8;

% Decision variables: number of shipments of each type (whole numbers)
var 0..1000: x1;
var 0..1000: x2;
var 0..800:  x3;
var 0..800:  x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 800;

% x1 - 0.5*x3 >= 200  ->  2*x1 - x3 >= 400
constraint 2*x1 - x3 >= 400;

% 0.25*x4 - x2 >= 150  ->  x4 - 4*x2 >= 600
constraint x4 - 4*x2 >= 600;

% Objective: minimize total cost
var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];