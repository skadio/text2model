% Parameters
% Cost per unit allocation (in dollars)
int: cost_X1 = 5000;
int: cost_X2 = 6000;
int: cost_X3 = 7000;
int: cost_X4 = 8000;

% Upper bounds on combined allocations
int: max_X1_X2 = 50;   % X1 + X2 <= 50
int: max_X3_X4 = 70;   % X3 + X4 <= 70

% Minimum required difference constraint
int: min_X1_minus_2X3 = 10;  % X1 - 2*X3 >= 10

% Limit on X2 minus twice X4
int: max_X2_minus_2X4 = 20;  % X2 - 2*X4 <= 20


% Variables
% Whole-number resource allocations to each initiative (non-negative)
var 0..max_X1_X2: X1;   % bounded above by X1+X2 <= 50
var 0..max_X1_X2: X2;   % bounded above by X1+X2 <= 50
var 0..max_X3_X4: X3;   % bounded above by X3+X4 <= 70
var 0..max_X3_X4: X4;   % bounded above by X3+X4 <= 70

% Total cost (bounded using the max possible allocations from the above bounds)
var 0..(max_X1_X2 * (cost_X1 + cost_X2) + max_X3_X4 * (cost_X3 + cost_X4)): total_cost;


% Constraints
% --- Budget/Resource coupling constraints (combined allocation limits) ---
constraint X1 + X2 <= max_X1_X2;
constraint X3 + X4 <= max_X3_X4;

% --- Strategic balance constraints ---
constraint X1 - 2 * X3 >= min_X1_minus_2X3;
constraint X2 - 2 * X4 <= max_X2_minus_2X4;

% --- Total cost definition ---
constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;


% Objective
solve minimize total_cost;