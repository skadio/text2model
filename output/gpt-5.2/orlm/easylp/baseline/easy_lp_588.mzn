% Resource allocation / production planning (integer) with embedded data

int: c1 = 20;
int: c2 = 30;
int: c3 = 40;
int: c4 = 50;

% Reasonable upper bounds implied by constraints; x1+x2<=200 gives natural caps.
var 0..200: x1;
var 0..200: x2;
var 0..200: x3;
var 0..200: x4;

% Constraints
constraint x1 + x2 <= 200;

constraint 2*x1 + 3*x3 >= 150;

% (x4/2 - x1) <= 75  ->  x4 - 2*x1 <= 150  (keeps everything integer)
constraint x4 - 2*x1 <= 150;

% x3 + x4/2 - x2 >= 100  ->  2*x3 + x4 - 2*x2 >= 200
constraint 2*x3 + x4 - 2*x2 >= 200;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n",
  "minimum_total_cost_rounded=", show(total_cost), "\n"
];