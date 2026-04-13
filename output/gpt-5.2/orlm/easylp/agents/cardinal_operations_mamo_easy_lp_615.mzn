% Parameters
int: cost_x1 = 500;          % Cost per unit resource for project X1
int: cost_x2 = 400;          % Cost per unit resource for project X2
int: cost_x3 = 300;          % Cost per unit resource for project X3
int: cost_x4 = 200;          % Cost per unit resource for project X4

int: cap_x1_x2 = 1000;       % Upper bound on X1 + X2
int: min_2x2_plus_x3 = 800;  % Lower bound on 2*X2 + X3

int: x4_at_least_diff_x1 = 200; % X4 <= X1 - 200
int: x4_at_least_diff_x2 = 150; % X4 <= X2 - 150

% Variable bounds (non-negative; use safe finite upper bound for search)
int: lb = 0;
int: ub = 10000;

% Variables
var lb..ub: x1;              % Resource allocation to project X1 (integer)
var lb..ub: x2;              % Resource allocation to project X2 (integer)
var lb..ub: x3;              % Resource allocation to project X3 (integer)
var lb..ub: x4;              % Resource allocation to project X4 (integer)

var 0..intmax: total_cost;   % Total cost (integer dollars)

% Constraints
% --- Capacity / budget limitation on combined allocation for X1 and X2 ---
constraint x1 + x2 <= cap_x1_x2;

% --- Minimum combined effort requirement: 2*X2 + X3 must reach threshold ---
constraint 2 * x2 + x3 >= min_2x2_plus_x3;

% --- Balanced distribution: X1 cannot exceed half of X3 (avoid division) ---
constraint 2 * x1 <= x3;

% --- Project X4 must be at least 200 fewer than X1: X4 <= X1 - 200 ---
constraint x4 <= x1 - x4_at_least_diff_x1;

% --- Project X4 must be at least 150 fewer than X2: X4 <= X2 - 150 ---
constraint x4 <= x2 - x4_at_least_diff_x2;

% --- Define total cost consistently with per-unit costs ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;