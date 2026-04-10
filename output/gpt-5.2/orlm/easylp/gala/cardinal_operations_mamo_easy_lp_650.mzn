% Shipping fleet allocation - cost minimization (all integer decision variables)

% Data (embedded as requested)
int: max12 = 1000;     % x1 + x2 <= 1000
int: max34 = 1500;     % x3 + x4 <= 1500

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

% Decision variables (nonnegative integers)
var 0..max12: x1;
var 0..max12: x2;
var 0..max34: x3;
var 0..max34: x4;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

% "x1 must be at least twice that of half the number of x3" => x1 >= 2*(x3/2) = x3
constraint x1 >= x3;

% "no more than half the number of x4 can be added ... without exceeding x2 by 400"
% Interpreted as: x2 + 400 >= x4/2  ->  2*x2 + 800 >= x4 (integer-safe)
constraint 2*x2 + 800 >= x4;

% Objective: minimize total operating cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_operating_cost=", show(total_cost), "\n"
];