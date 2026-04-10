% Resource allocation MILP (integer) - all data embedded

int: max_x1 = 150;
int: max_x2 = 100;
int: max_x3 = 80;
int: max_x4 = 20;

int: cost_x1 = 10000;
int: cost_x2 = 5000;
int: cost_x3 = 8000;
int: cost_x4 = 6000;

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Objective: minimize total support points
var int: total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Constraints
constraint x1 + x2 <= 200;

% 2*x1 + 3.5*x3 >= 400  -> 4*x1 + 7*x3 >= 800 (multiply by 2)
constraint 4*x1 + 7*x3 >= 800;

% |x2 - 0.5*x4| <= 50  -> |2*x2 - x4| <= 100
constraint abs(2*x2 - x4) <= 100;

% x2 - x1 - x3 <= 70
constraint x2 - x1 - x3 <= 70;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_support_points=", show(total_cost), "\n"
];