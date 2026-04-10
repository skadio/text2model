% Investment allocation problem (all data embedded)

% Decision variables: number of units invested in each option (nonnegative integers)
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;

% Costs per unit
int: c1 = 500;
int: c2 = 400;
int: c3 = 300;

% Budget limit on total cost
constraint c1*x1 + c2*x2 + c3*x3 <= 10000;

% (1/2)*x1 - (1/4)*x2 >= 2000  ->  2*x1 - x2 >= 8000
constraint 2*x1 - x2 >= 8000;

% x3 - x1 <= 500
constraint x3 - x1 <= 500;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "min_total_cost=", show(total_cost), "\n"
];