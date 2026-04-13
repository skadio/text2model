% Parameters
% Cost per truck on each route
int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;
int: cost_x4 = 7;

% Capacity/upper-bound constraints on pairs of routes
int: max_x1_x2 = 50;   % X1 + X2 <= 50
int: max_x3_x4 = 80;   % X3 + X4 <= 80

% Minimum allocation constraints on pairs of routes
int: min_x1_x3 = 30;   % X1 + X3 >= 30
int: min_x2_x4 = 40;   % X2 + X4 >= 40

% Derived safe upper bounds for individual route decision variables
% (from pairwise maxima and non-negativity)
int: ub_x1 = max_x1_x2;
int: ub_x2 = max_x1_x2;
int: ub_x3 = max_x3_x4;
int: ub_x4 = max_x3_x4;

% Variables
% Number of trucks assigned to each route (must be whole numbers)
var 0..ub_x1: x1;  % trucks on route X1
var 0..ub_x2: x2;  % trucks on route X2
var 0..ub_x3: x3;  % trucks on route X3
var 0..ub_x4: x4;  % trucks on route X4

% Total cost to minimize (integer cost since all inputs/vars are integers)
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
% Pairwise maximum (capacity) constraints
constraint x1 + x2 <= max_x1_x2;   % X1 + X2 cannot exceed 50
constraint x3 + x4 <= max_x3_x4;   % X3 + X4 cannot exceed 80

% Pairwise minimum allocation constraints
constraint x1 + x3 >= min_x1_x3;   % Ensure at least 30 trucks across X1 and X3
constraint x2 + x4 >= min_x2_x4;   % Ensure at least 40 trucks across X2 and X4

% Total cost definition (linking constraint)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;