% Parameters
% Cost per unit for each service
float: c1 = 0.5;
float: c2 = 0.2;
float: c3 = 3.0;
float: c4 = 1.5;

% Constraint limits
int: max_x1_x2 = 200;     % x1 + x2 <= 200
int: max_x3_x4 = 180;     % x3 + x4 <= 180

% Variable bounds (operational limits)
int: x1_min = 50;  int: x1_max = 150;
int: x2_min = 80;  int: x2_max = 120;
int: x3_min = 20;  int: x3_max = 70;
int: x4_min = 30;  int: x4_max = 60;


% Variables
% Integer allocations to each service
var x1_min..x1_max: x1;   % resources allocated to service 1
var x2_min..x2_max: x2;   % resources allocated to service 2
var x3_min..x3_max: x3;   % resources allocated to service 3
var x4_min..x4_max: x4;   % resources allocated to service 4

% Total cost (kept as float because costs are fractional)
var float: total_cost;    % objective value before rounding

% Rounded total cost to nearest whole number (as requested)
var int: total_cost_rounded;


% Constraints

% --- Capacity / combined allocation constraints ---
constraint x1 + x2 <= max_x1_x2;    % Combined allocation for services 1 and 2
constraint x3 + x4 <= max_x3_x4;    % Combined allocation for services 3 and 4

% --- Strategic emphasis constraints (avoid float coercion by clearing denominators) ---
constraint 7 * x1 - 10 * x3 >= 0;   % 0.7*x1 - x3 >= 0  <=>  7*x1 >= 10*x3
constraint x2 - 2 * x4 >= 0;        % 0.5*x2 - x4 >= 0  <=>  x2 >= 2*x4

% --- Total cost definition ---
constraint
  total_cost = c1 * int2float(x1)
             + c2 * int2float(x2)
             + c3 * int2float(x3)
             + c4 * int2float(x4);

% --- Rounding to nearest whole number ---
constraint total_cost_rounded = round(total_cost);


% Objective
solve minimize total_cost_rounded;