% Parameters
int: cost_x1 = 5;              % Unit cost for project x1
int: cost_x2 = 4;              % Unit cost for project x2
int: cost_x3 = 3;              % Unit cost for project x3

int: x1_min = 0;               % Minimum allocation for x1
int: x1_max = 500;             % Maximum allocation for x1
int: x2_min = 0;               % Minimum allocation for x2
int: x2_max = 300;             % Maximum allocation for x2
int: x3_min = 0;               % Minimum allocation for x3
int: x3_max = 400;             % Maximum allocation for x3

int: rhs_c1 = 1000;            % RHS for constraint 1 (upper bound)
int: rhs_c2 = 500;             % RHS for constraint 2 (lower bound)
int: rhs_c3 = 200;             % RHS for constraint 3 (equality)

% Variables
var x1_min..x1_max: x1;        % Integer allocation to project x1
var x2_min..x2_max: x2;        % Integer allocation to project x2
var x3_min..x3_max: x3;        % Integer allocation to project x3

% Total cost variable (bounded by worst-case max cost)
var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost;

% Constraints
%--- Budgetary / resource allocation constraints ---
constraint x1 + 2 * x2 <= rhs_c1;                 % C1: x1 + 2*x2 cannot exceed 1000
constraint 3 * x1 - x2 + x3 >= rhs_c2;            % C2: 3*x1 - x2 + x3 must be at least 500
constraint -x1 + 4 * x2 - 2 * x3 = rhs_c3;        % C3: -x1 + 4*x2 - 2*x3 must equal 200

%--- Total cost definition (linking variable total_cost to allocations) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;