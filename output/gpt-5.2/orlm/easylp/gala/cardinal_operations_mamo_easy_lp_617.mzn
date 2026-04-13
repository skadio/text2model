include "globals.mzn";

% Data (embedded as required)
int: c1 = 200;
int: c2 = 300;
int: c3 = 150;
int: c4 = 400;

int: max1 = 1000;
int: max2 = 1000;
int: max3 = 1200;
int: max4 = 1000;

% Decision variables: integer resource allocations
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;
var 0..max4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2 * x2 + x3 <= 1200;

% 3*x1 - 0.5*x3 >= 500  ->  multiply by 2 to keep integers:
constraint 6 * x1 - x3 >= 1000;

constraint x4 >= x1;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];