% Parameters
% Cost per unit allocated to each tour type (x1..x4)
array[1..4] of int: cost = [100, 200, 300, 400];

% Upper bounds on allocations for each tour (x1..x4)
array[1..4] of int: ub = [500, 500, 600, 600];

% Constraint right-hand sides
int: cap12 = 500;     % x1 + x2 <= 500
int: cap34 = 600;     % x3 + x4 <= 600
int: min13 = 300;     % x1 + x3 >= 300
int: min24 = 400;     % x2 + x4 >= 400


% Variables
% Allocation for each tour type (whole number of units)
array[1..4] of var 0..max(ub): x;

% Total cost to minimize
var int: total_cost;


% Constraints
% Explicit bounds per tour (also implied by var domain above, kept for clarity)
constraint forall(i in 1..4) (x[i] <= ub[i]);

% Link objective variable
constraint total_cost = sum(i in 1..4)(cost[i] * x[i]);

% --- Capacity constraints (budget / maximum combined allocations) ---
constraint x[1] + x[2] <= cap12;   % x1 + x2 cannot exceed 500
constraint x[3] + x[4] <= cap34;   % x3 + x4 cannot exceed 600

% --- Minimum diversity / demand satisfaction constraints ---
constraint x[1] + x[3] >= min13;   % x1 + x3 must be at least 300
constraint x[2] + x[4] >= min24;   % x2 + x4 must be at least 400

% Note: No extra integrality constraint is needed because x is declared as var int.


% Objective
solve minimize total_cost;