% Military logistics resource allocation - all data embedded

var 0..300: x1;
var 0..250: x2;
var 0..400: x3;
var 0..350: x4;

% Costs ($ per resource)
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Constraints
constraint x1 + x2 >= 200;
constraint abs(x3 - x4) <= 50;

% 2*x2 - x1 - 0.5*x3 <= 100  -> multiply by 2 to keep integer:
constraint 4*x2 - 2*x1 - x3 <= 200;

% (3/4)*x1 = x4 + 150  -> 3*x1 = 4*(x4+150)
constraint 3*x1 = 4*x4 + 600;

constraint x1 + x2 + x3 + x4 <= 500;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];