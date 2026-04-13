% Parameters
% Cost per person in each tour package
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

% Capacity / budget-limitation upper bounds
int: max_x1_x2 = 500;  % x1 + x2 <= 500
int: max_x3_x4 = 700;  % x3 + x4 <= 700

% Minimum mix / variety requirements
int: min_x1_x3 = 200;  % x1 + x3 >= 200
int: min_x2_x4 = 300;  % x2 + x4 >= 300


% Variables
% Number of people assigned to each tour package (non-negative integers)
var 0..max_x1_x2: x1;  % bounded by x1+x2 <= 500
var 0..max_x1_x2: x2;  % bounded by x1+x2 <= 500
var 0..max_x3_x4: x3;  % bounded by x3+x4 <= 700
var 0..max_x3_x4: x4;  % bounded by x3+x4 <= 700

% Total cost (bounded using the variable upper bounds)
var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;


% Constraints
% --- Total cost definition (linking variable) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% --- Capacity / budget limitation constraints ---
constraint
  x1 + x2 <= max_x1_x2;

constraint
  x3 + x4 <= max_x3_x4;

% --- Minimum mix / variety requirements ---
constraint
  x1 + x3 >= min_x1_x3;

constraint
  x2 + x4 >= min_x2_x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];