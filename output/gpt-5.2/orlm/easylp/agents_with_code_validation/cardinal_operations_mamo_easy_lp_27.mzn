% Parameters
% Daily operating cost per vehicle type
int: cost_X = 4;
int: cost_Y = 5;

% Road capacity constraint coefficients and bound: 2*X + 3*Y <= 1000
int: cap_aX = 2;
int: cap_aY = 3;
int: cap_ub = 1000;

% Demand constraint coefficients and bound: 3*X + 2*Y >= 800
int: dem_aX = 3;
int: dem_aY = 2;
int: dem_lb = 800;

% Variables
% Number of vehicles of each type to operate (integer, non-negative)
var 0..cap_ub: x;  % vehicles of type X
var 0..cap_ub: y;  % vehicles of type Y

% Total daily cost (bounded for safe use in linear expressions)
var 0..(cost_X*cap_ub + cost_Y*cap_ub): total_cost;

% Constraints
% --- Road capacity constraint (cannot exceed daily capacity) ---
constraint cap_aX * x + cap_aY * y <= cap_ub;

% --- Demand satisfaction constraint (must meet at least daily demand) ---
constraint dem_aX * x + dem_aY * y >= dem_lb;

% --- Define total daily operating cost from chosen fleet sizes ---
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;