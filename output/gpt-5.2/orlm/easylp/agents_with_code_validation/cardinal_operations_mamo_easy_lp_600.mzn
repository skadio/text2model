% Parameters
% Budget limit
int: total_budget = 100000;

% Investment bounds (in dollars)
int: x1_min = 10000;
int: x1_max = 60000;

int: x2_min = 20000;
int: x2_max = 80000;

int: x3_min = 15000;
int: x3_max = 50000;

int: x4_min = 200;
% No explicit upper limit for X4; derive a safe upper bound from total budget
int: x4_max = total_budget;

% Constraint parameters
int: slack_x3x4_vs_x1x2 = 30000;  % (X1+X2) - (X3+X4) <= 30000
int: diff_x3_x4_limit = 500;      % 0.7*X3 - 0.5*X4 <= 500

% Cost rates
float: c1 = 0.05;
float: c2 = 0.08;
float: c3 = 0.12;
float: c4 = 0.15;

% Scaling to keep fractional constraints linear in integers
int: scale = 10;        % represents tenths exactly
int: money_scale = 100; % cents per dollar (for objective)

% Precomputed integer cents-per-dollar costs to avoid float-int coercion in constraints
int: c1_cents = 5;   % 0.05 * 100
int: c2_cents = 8;   % 0.08 * 100
int: c3_cents = 12;  % 0.12 * 100
int: c4_cents = 15;  % 0.15 * 100


% Variables
% Investments (integer dollars)
var x1_min..x1_max: x1;     % dollars invested in asset X1
var x2_min..x2_max: x2;     % dollars invested in asset X2
var x3_min..x3_max: x3;     % dollars invested in asset X3
var x4_min..x4_max: x4;     % dollars invested in asset X4

% Total cost in cents (integer, exact)
var 0..(c4_cents * total_budget): total_cost_cents;  % conservative upper bound


% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint x1 + x2 + x3 + x4 <= total_budget;

% Investment relationship: 60% of X1 minus 40% of X2 must be non-negative
% Scaled by 10: 6*x1 - 4*x2 >= 0
constraint (6 * x1) - (4 * x2) >= 0;

% Allocation balance: (X1+X2) - (X3+X4) <= slack
constraint (x1 + x2) - (x3 + x4) <= slack_x3x4_vs_x1x2;

% Relative difference constraint: 70% of X3 minus 50% of X4 should not exceed 500
% Scaled by 10: 7*x3 - 5*x4 <= 10*500
constraint (7 * x3) - (5 * x4) <= scale * diff_x3_x4_limit;

% Total cost computation in cents (exact integer arithmetic)
constraint total_cost_cents = c1_cents * x1 + c2_cents * x2 + c3_cents * x3 + c4_cents * x4;


% Objective
solve minimize total_cost_cents;