% Parameters
% Unit costs per resource unit for each department
int: cost_x1 = 500;
int: cost_x2 = 600;
int: cost_x3 = 800;
int: cost_x4 = 700;

% Capacity limits for paired departments
int: cap_x1_x2 = 100;   % x1 + x2 <= 100
int: cap_x3_x4 = 50;    % x3 + x4 <= 50

% Strategic rebalancing requirements
int: min_diff_x34_minus_x12 = 30;  % (x3 + x4) - (x1 + x2) >= 30

% The prompt mentions "specific bounds" but provides none; use safe implied upper bounds.
int: ub_x1 = cap_x1_x2;
int: ub_x2 = cap_x1_x2;
int: ub_x3 = cap_x3_x4;
int: ub_x4 = cap_x3_x4;


% Variables
var 0..ub_x1: x1;  % resources allocated to department x1 (integer units)
var 0..ub_x2: x2;  % resources allocated to department x2 (integer units)
var 0..ub_x3: x3;  % resources allocated to department x3 (integer units)
var 0..ub_x4: x4;  % resources allocated to department x4 (integer units)

var int: total_cost; % total cost to minimize


% Constraints
% --- Capacity constraints for paired departments ---
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

% --- Strategic rebalancing constraints ---
constraint x3 >= 2 * x1;          % x3 should be at least twice x1

% Integer-safe "x4 >= 3/4 * x2"  <=>  4*x4 >= 3*x2
constraint 4 * x4 >= 3 * x2;      % x4 no less than three quarters of x2

constraint (x3 + x4) - (x1 + x2) >= min_diff_x34_minus_x12;

% --- Cost definition (link total_cost to decision variables) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;