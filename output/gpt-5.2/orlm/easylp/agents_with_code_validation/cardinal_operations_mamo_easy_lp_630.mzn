% Parameters
int: cost_x1 = 500;          % cost per unit for department x1
int: cost_x2 = 600;          % cost per unit for department x2
int: cost_x3 = 800;          % cost per unit for department x3
int: cost_x4 = 700;          % cost per unit for department x4

int: cap_x1x2 = 100;         % maximum combined allocation for x1 + x2
int: cap_x3x4 = 50;          % maximum combined allocation for x3 + x4

int: rebalance_min = 30;     % minimum (x3+x4) - (x1+x2)

% Derived safe upper bounds from the given caps (and non-negativity)
int: ub_x1 = cap_x1x2;
int: ub_x2 = cap_x1x2;
int: ub_x3 = cap_x3x4;
int: ub_x4 = cap_x3x4;

% Variables
var 0..ub_x1: x1;            % integer allocation for department x1
var 0..ub_x2: x2;            % integer allocation for department x2
var 0..ub_x3: x3;            % integer allocation for department x3
var 0..ub_x4: x4;            % integer allocation for department x4

var int: total_cost;         % total cost to minimize

% Constraints

% --- Capacity constraints (budgetary limits on combined allocations) ---
constraint x1 + x2 <= cap_x1x2;
constraint x3 + x4 <= cap_x3x4;

% --- Strategic shift constraints (relative allocation requirements) ---
constraint x3 >= 2 * x1;

% x4 should be no less than three quarters of x2 (clear fractions by *4)
constraint 4 * x4 >= 3 * x2;

% --- Rebalancing constraint (net shift towards x3 and x4) ---
constraint (x3 + x4) - (x1 + x2) >= rebalance_min;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;