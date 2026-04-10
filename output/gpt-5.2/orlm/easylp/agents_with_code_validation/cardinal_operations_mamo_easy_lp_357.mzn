% Parameters
% Unit costs (USD per unit)
float: cost_x1 = 1.5;
float: cost_x2 = 2.0;
float: cost_x3 = 3.0;
float: cost_x4 = 4.0;

% Capacity / demand constraints
int: cap_x1_x2 = 500;     % x1 + x2 <= 500
int: cap_x3_x4 = 300;     % x3 + x4 <= 300
int: min_x1_x3 = 200;     % x1 + x3 >= 200
int: min_x2_x4 = 100;     % x2 + x4 >= 100

% Individual stock bounds
int: x1_min = 0;   int: x1_max = 250;
int: x2_min = 0;   int: x2_max = 250;
int: x3_min = 0;   int: x3_max = 150;
int: x4_min = 0;   int: x4_max = 150;

% Variables
var x1_min..x1_max: x1;   % units of product x1 (integer)
var x2_min..x2_max: x2;   % units of product x2 (integer)
var x3_min..x3_max: x3;   % units of product x3 (integer)
var x4_min..x4_max: x4;   % units of product x4 (integer)

% Total cost in cents (integer) to avoid float objective
var 0..10000000: total_cost_cents; % safely above any feasible total

% Constraints
% --- Pairwise capacity constraints (storage limits by grouped categories) ---
constraint x1 + x2 <= cap_x1_x2;   % x1 + x2 cannot exceed combined capacity
constraint x3 + x4 <= cap_x3_x4;   % x3 + x4 cannot exceed combined capacity

% --- Minimum demand/coverage constraints (ensure required stock levels) ---
constraint x1 + x3 >= min_x1_x3;   % ensure enough stock from (x1,x3) category
constraint x2 + x4 >= min_x2_x4;   % ensure enough stock from (x2,x4) category

% --- Total cost linking constraint (in cents; integer-safe, avoids floats) ---
constraint total_cost_cents =
  150 * x1 + 200 * x2 + 300 * x3 + 400 * x4;

% Objective
solve minimize total_cost_cents;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=$", show(total_cost_cents div 100), ".", show((total_cost_cents mod 100) div 10), show(total_cost_cents mod 10), "\n",
  "rounded_total_cost=$", show((total_cost_cents + 50) div 100), "\n"
];