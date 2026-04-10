% Parameters
int: cost_x1 = 100;                 % Cost per person in package x1
int: cost_x2 = 200;                 % Cost per person in package x2
int: cost_x3 = 300;                 % Cost per person in package x3
int: cost_x4 = 400;                 % Cost per person in package x4

int: max_x1_x2 = 500;               % Upper bound on x1 + x2
int: max_x3_x4 = 700;               % Upper bound on x3 + x4
int: min_x1_x3 = 200;               % Lower bound on x1 + x3
int: min_x2_x4 = 300;               % Lower bound on x2 + x4

% Variables
var 0..max_x1_x2: x1;               % Number of people in package x1
var 0..max_x1_x2: x2;               % Number of people in package x2
var 0..max_x3_x4: x3;               % Number of people in package x3
var 0..max_x3_x4: x4;               % Number of people in package x4

var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;
                                     % Total cost (bounded by max possible given variable bounds)

% Constraints
% --- Capacity / upper-bound constraints ---
constraint x1 + x2 <= max_x1_x2;     % Combined people in packages x1 and x2 cannot exceed limit
constraint x3 + x4 <= max_x3_x4;     % Combined people in packages x3 and x4 cannot exceed limit

% --- Minimum participation / balance constraints ---
constraint x1 + x3 >= min_x1_x3;     % Ensure at least a minimum total in packages x1 and x3
constraint x2 + x4 >= min_x2_x4;     % Ensure at least a minimum total in packages x2 and x4

% --- Total cost definition constraint ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;