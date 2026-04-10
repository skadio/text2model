% Parameters
% Unit costs ($/unit) for each project x1..x4
int: cost_x1 = 200;
int: cost_x2 = 300;
int: cost_x3 = 400;
int: cost_x4 = 500;

% Constraint limits
int: max_x1_x2 = 1000;      % x1 + x2 <= 1000
int: max_2x3_x4 = 1200;     % 2*x3 + x4 <= 1200
int: min_total = 500;       % x1 + x2 + x3 + x4 >= 500

% NOTE: The statement mentions specific bounds but provides no numeric bounds.
% We therefore model non-negativity only.
int: lb = 0;

% Variables
% Allocations (whole units). Upper bounds can be inferred from constraints to aid propagation.
var lb..max_x1_x2: x1;                 % residential allocation
var lb..max_x1_x2: x2;                 % commercial allocation
var lb..(max_2x3_x4 div 2): x3;         % industrial allocation (since 2*x3 <= max_2x3_x4)
var lb..max_2x3_x4: x4;                % infrastructure allocation

% Total cost (bounded for better solver performance)
var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*(max_2x3_x4 div 2) + cost_x4*max_2x3_x4): total_cost;

% Constraints
% --- Budgetary limitation constraints ---
constraint x1 + x2 <= max_x1_x2;
constraint 2 * x3 + x4 <= max_2x3_x4;
constraint x1 + x2 + x3 + x4 >= min_total;

% --- Cost aggregation constraint ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;