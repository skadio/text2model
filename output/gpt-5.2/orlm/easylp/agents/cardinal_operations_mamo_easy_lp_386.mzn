% Parameters
% Cost per tour category (embedded from problem statement)
int: cost_x1 = 50;
int: cost_x2 = 100;
int: cost_x3 = 70;
int: cost_x4 = 120;

% Capacity limits (embedded)
int: cap_12 = 500;   % x1 + x2 <= 500
int: cap_34 = 300;   % x3 + x4 <= 300

% Demand thresholds (embedded)
int: demand_12 = 400; % 2*x1 + 4*x2 >= 400
int: demand_34 = 250; % 3*x3 + 2*x4 >= 250


% Variables
% Number of tours offered in each category (must be whole numbers, non-negative)
var 0..cap_12: x1;  % bounded by x1+x2 <= cap_12
var 0..cap_12: x2;  % bounded by x1+x2 <= cap_12
var 0..cap_34: x3;  % bounded by x3+x4 <= cap_34
var 0..cap_34: x4;  % bounded by x3+x4 <= cap_34

% Total cost (bounded using maximum possible within caps)
var 0..(cost_x1*cap_12 + cost_x2*cap_12 + cost_x3*cap_34 + cost_x4*cap_34): total_cost;


% Constraints
% --- Capacity constraints (resource/logistics limits) ---
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

% --- Demand satisfaction constraints (minimum service levels) ---
constraint 2 * x1 + 4 * x2 >= demand_12;
constraint 3 * x3 + 2 * x4 >= demand_34;

% --- Total cost definition (link decision variables to total_cost) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;