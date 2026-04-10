% Parameters
% Fatigue coefficients for each training group
int: fatigue_x1 = 10;
int: fatigue_x2 = 15;
int: fatigue_x3 = 12;
int: fatigue_x4 = 20;

% Schedule limitation bounds
int: max_x1_x2 = 8;    % x1 + x2 <= 8
int: max_x3_x4 = 10;   % x3 + x4 <= 10
int: min_x1_x3 = 5;    % x1 + x3 >= 5
int: min_x2_x4 = 6;    % x2 + x4 >= 6

% Group-specific weekly hour bounds (assumed nonnegative integers)
int: lb_x1 = 0; int: ub_x1 = 100;
int: lb_x2 = 0; int: ub_x2 = 100;
int: lb_x3 = 0; int: ub_x3 = 100;
int: lb_x4 = 0; int: ub_x4 = 100;

% Variables
var lb_x1..ub_x1: x1; % weekly hours for group x1 (skill development)
var lb_x2..ub_x2: x2; % weekly hours for group x2 (strength conditioning)
var lb_x3..ub_x3: x3; % weekly hours for group x3 (strategy training)
var lb_x4..ub_x4: x4; % weekly hours for group x4 (recovery sessions)

var int: total_fatigue; % total fatigue score (objective)

% Constraints
% --- Schedule limitation constraints (upper bounds) ---
constraint x1 + x2 <= max_x1_x2;  % <= 8
constraint x3 + x4 <= max_x3_x4;  % <= 10

% --- Balanced schedule constraints (lower bounds) ---
constraint x1 + x3 >= min_x1_x3;  % >= 5
constraint x2 + x4 >= min_x2_x4;  % >= 6

% --- Total fatigue definition ---
constraint
  total_fatigue =
    fatigue_x1 * x1 +
    fatigue_x2 * x2 +
    fatigue_x3 * x3 +
    fatigue_x4 * x4;

% Objective
solve minimize total_fatigue;

% Optional output for clarity
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];