% Parameters
int: cost_x1 = 4;                 % Operating cost per truck on Route X1
int: cost_x2 = 5;                 % Operating cost per truck on Route X2
int: cost_x3 = 6;                 % Operating cost per truck on Route X3

int: max_x1 = 1500;               % Upper bound on trucks for Route X1
int: max_x2 = 1200;               % Upper bound on trucks for Route X2
int: max_x3 = 800;                % Upper bound on trucks for Route X3

int: cap_x1_x2 = 2000;            % Capacity limit for combined trucks on X1 and X2
int: min_x2_x3 = 1000;            % Minimum service requirement for combined trucks on X2 and X3
int: balance_rhs = 500;           % RHS for balance constraint: X1 - 2*X3 = 500

% Variables
var 0..max_x1: x1;                % Trucks allocated to Route X1
var 0..max_x2: x2;                % Trucks allocated to Route X2
var 0..max_x3: x3;                % Trucks allocated to Route X3

% Total operating cost (tight upper bound from max allocations)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3): total_cost;

% Constraints
% Capacity limit: combined trucks on Route X1 and Route X2 cannot exceed cap_x1_x2
constraint x1 + x2 <= cap_x1_x2;

% Service requirement: combined trucks on Route X2 and Route X3 must be at least min_x2_x3
constraint x2 + x3 >= min_x2_x3;

% Balance/strategic constraint: X1 minus twice X3 must equal balance_rhs
constraint x1 - 2 * x3 = balance_rhs;

% Total operating cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;