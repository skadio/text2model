% Parameters
% Unit costs (in dollars) for each product type
float: cost_x1 = 1.5;
float: cost_x2 = 2.0;
float: cost_x3 = 3.0;
float: cost_x4 = 4.0;

% Capacity limits
int: cap_x1_x2 = 500;   % x1 + x2 <= 500
int: cap_x3_x4 = 300;   % x3 + x4 <= 300

% Minimum demand requirements
int: min_x1_x3 = 200;   % x1 + x3 >= 200
int: min_x2_x4 = 100;   % x2 + x4 >= 100

% Individual storage bounds
int: x1_lb = 0;   int: x1_ub = 250;
int: x2_lb = 0;   int: x2_ub = 250;
int: x3_lb = 0;   int: x3_ub = 150;
int: x4_lb = 0;   int: x4_ub = 150;


% Variables
% Decision variables: number of units to stock (must be whole numbers)
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (continuous due to fractional unit costs)
var float: total_cost;


% Constraints
% --- Capacity constraints (storage limits for combined product groups) ---
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

% --- Demand fulfillment constraints (minimum required units by category pairing) ---
constraint x1 + x3 >= min_x1_x3;
constraint x2 + x4 >= min_x2_x4;

% --- Total cost definition (linking decision variables to total cost) ---
constraint
  total_cost =
      cost_x1 * int2float(x1)
    + cost_x2 * int2float(x2)
    + cost_x3 * int2float(x3)
    + cost_x4 * int2float(x4);


% Objective
solve minimize total_cost;