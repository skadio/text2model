% Shipping fleet allocation - all data embedded

int: C1 = 50;
int: C2 = 60;
int: C3 = 70;
int: C4 = 80;

% Decision variables (nonnegative integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1500: x3;
var 0..1500: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 1500;

% "x1 must be at least twice that of half the number of x3" => x1 >= x3
constraint x1 >= x3;

% "no more than half the number of x4 can be added without exceeding x2 by 400"
% interpreted as: x2 <= 400 + (1/2)*x4  =>  2*x2 <= 800 + x4
constraint 2*x2 <= 800 + x4;

% Objective: minimize total operating cost
var int: total_cost = C1*x1 + C2*x2 + C3*x3 + C4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_operating_cost=", show(total_cost), "\n"
];