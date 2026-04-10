% Parameters
% Unit production costs ($/unit)
int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 70;
int: cost_x4 = 80;

% Capacity upper bounds (units)
int: max_x1 = 600;
int: max_x2 = 400;
int: max_x3 = 500;
int: max_x4 = 300;

% Constraint limits (units)
int: limit_x1_x2 = 1000;     % x1 + x2 <= 1000
int: limit_x3_x4 = 1200;     % 2*x3 + 3*x4 <= 1200
int: min_total_prod = 500;   % x1 + x2 + x3 + x4 >= 500


% Variables
% Production quantities (whole units)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Total production cost ($)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;


% Constraints
% Link total cost to production quantities
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Supply/market constraint: combined output of x1 and x2
constraint
  x1 + x2 <= limit_x1_x2;

% Supply/market constraint: weighted output of x3 and x4
constraint
  2 * x3 + 3 * x4 <= limit_x3_x4;

% Minimum total production requirement
constraint
  x1 + x2 + x3 + x4 >= min_total_prod;

% Product-mix balancing: x1 exceeds half of x3 (avoid fractional by multiplying)
constraint
  2 * x1 > x3;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];