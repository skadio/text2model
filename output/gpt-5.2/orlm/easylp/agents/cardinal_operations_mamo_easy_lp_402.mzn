% Parameters
%-----------------------------
% Embedded problem data (no .dzn)
%-----------------------------

int: max_X1_X2 = 1000;            % X1 + X2 <= 1000
int: min_2X1_plus_X3 = 800;       % 2*X1 + X3 >= 800
int: max_X2_plus_3X4 = 600;       % X2 + 3*X4 <= 600
int: min_X1_minus_halfX4 = 200;   % X1 - (1/2)*X4 >= 200

int: cost_X1 = 2;
int: cost_X2 = 3;
int: cost_X3 = 4;
int: cost_X4 = 5;

% Safe explicit upper bounds (sufficient for cost-minimization)
int: UB_X1 = 1000;
int: UB_X2 = 1000;
int: UB_X3 = 800;
int: UB_X4 = 200;

% Variables
%-----------------------------
% Integer allocations (nonnegative)
%-----------------------------
var 0..UB_X1: X1;
var 0..UB_X2: X2;
var 0..UB_X3: X3;
var 0..UB_X4: X4;

% Total cost (integer)
var 0..(cost_X1*UB_X1 + cost_X2*UB_X2 + cost_X3*UB_X3 + cost_X4*UB_X4): total_cost;

% Constraints
%-----------------------------
% Feasibility / resource limits
%-----------------------------

% Logistics capacity: X1 + X2 <= 1000
constraint X1 + X2 <= max_X1_X2;

% Strategic requirement: 2*X1 + X3 >= 800
constraint 2 * X1 + X3 >= min_2X1_plus_X3;

% Resource limitation: X2 + 3*X4 <= 600
constraint X2 + 3 * X4 <= max_X2_plus_3X4;

% Difference requirement without fractions:
% X1 - (1/2)*X4 >= 200  <=>  2*X1 - X4 >= 400
constraint 2 * X1 - X4 >= 2 * min_X1_minus_halfX4;

%-----------------------------
% Cost definition (linking var)
%-----------------------------
constraint total_cost =
    cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% Objective
solve minimize total_cost;