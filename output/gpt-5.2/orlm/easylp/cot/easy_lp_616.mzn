% Parameters (with values embedded)
int: cost_X1 = 100;
int: cost_X2 = 200;
int: cost_X3 = 150;
int: cost_X4 = 50;

int: ub_X1 = 500;
int: ub_X2 = 300;
int: ub_X3 = 200;
int: ub_X4 = 400;

% Variables
var 0..ub_X1: X1;
var 0..ub_X2: X2;
var 0..ub_X3: X3;
var 0..ub_X4: X4;

% Constraints
constraint X1 + X2 <= 1000;
constraint 2 * X1 + X3 >= 800;

% X4 should not be less than half of X1: X4 >= X1/2.
% Use integer-safe form to avoid fractions.
constraint 2 * X4 >= X1;

% The difference between (X3/4) and X2 should not exceed 500.
% Since allocations are integers, interpret as: |X3 - 4*X2| <= 2000.
constraint abs(X3 - 4 * X2) <= 2000;

% Balance constraint: (X2 + X4) - (X1 + X3) = 70
constraint X2 + X4 - X1 - X3 = 70;

% Objective
var int: total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;
solve minimize total_cost;