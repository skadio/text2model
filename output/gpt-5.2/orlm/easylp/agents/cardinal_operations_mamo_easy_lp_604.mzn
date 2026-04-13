% Parameters
% Budget requirement for departments x1 and x2 (must sum exactly to this)
int: sum_x1_x2 = 400;

% Maximum allocations (units) for each department
int: max_x1 = 300;
int: max_x2 = 200;
int: max_x3 = 500;
int: max_x4 = 700;

% Upper bound on combined allocation for departments x3 and x4
int: max_sum_x3_x4 = 1000;

% Unit costs ($ per unit) for each department
int: cost_x1 = 20;
int: cost_x2 = 15;
int: cost_x3 = 10;
int: cost_x4 = 5;


% Variables
% Allocation amounts (whole units) for each department
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Total cost in dollars (bounded using max allocations)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;


% Constraints
% Sum requirement for departments x1 and x2 (must equal exactly 400)
constraint x1 + x2 = sum_x1_x2;

% Combined upper bound for departments x3 and x4
constraint x3 + x4 <= max_sum_x3_x4;

% Combined allocation for x3 and x4 must be at least that for x1 and x2
constraint x3 + x4 >= x1 + x2;

% Define total cost from allocations and unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;