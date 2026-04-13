% Parameters
int: cost_x1 = 3;            % Unit cost for project X1
int: cost_x2 = 2;            % Unit cost for project X2
int: cost_x3 = 5;            % Unit cost for project X3

int: max_total_alloc = 1000; % Maximum combined allocation for all projects

int: lhs1_a = 2;             % Coefficient for X1 in constraint: 2*X1 - 3*X3 >= 500
int: lhs1_c = 3;             % Coefficient for X3 in constraint: 2*X1 - 3*X3 >= 500
int: rhs1 = 500;             % Right-hand side for constraint: 2*X1 - 3*X3 >= 500

int: lhs2_b = 4;             % Coefficient for X2 in constraint: 4*X2 + X3 <= 1200
int: rhs2 = 1200;            % Right-hand side for constraint: 4*X2 + X3 <= 1200

int: x1_max = 400;           % Maximum allocation for project X1
int: x2_max = 300;           % Maximum allocation for project X2
int: x3_max = 600;           % Maximum allocation for project X3

% Variables
var 0..x1_max: x1;           % Integer allocation to project X1
var 0..x2_max: x2;           % Integer allocation to project X2
var 0..x3_max: x3;           % Integer allocation to project X3

% Total cost (bounded by maximum possible spend under variable upper bounds)
var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost;

% Constraints
% Define total cost
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% --- Total allocation budget constraint ---
constraint x1 + x2 + x3 <= max_total_alloc;

% --- Importance/complexity constraint: 2*X1 - 3*X3 >= 500 ---
constraint lhs1_a * x1 - lhs1_c * x3 >= rhs1;

% --- Capacity/feasibility constraint: 4*X2 + X3 <= 1200 ---
constraint lhs2_b * x2 + x3 <= rhs2;

% Objective
solve minimize total_cost;