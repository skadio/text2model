% Parameters
% Unit production costs for products X1..X4
int: cost_x1 = 5;
int: cost_x2 = 10;
int: cost_x3 = 20;
int: cost_x4 = 25;

% Constraint constants
int: max_x1_x2 = 100;     % X1 + X2 <= 100
int: max_x3_x4 = 200;     % 2*X3 + 3*X4 <= 200 (resource/capacity limit)
int: min_mix = 50;        % X1 - 2*X2 + X3 >= 50
int: max_diff = 70;       % X1 - (X2 + X3) <= 70

% Lower bound for production quantities (nonnegative integer production)
int: lb = 0;

% Variables
var lb..max_x1_x2: x1;                % units of product X1
var lb..max_x1_x2: x2;                % units of product X2
var lb..(max_x3_x4 div 2): x3;        % units of product X3 (since 2*x3 <= 200)
var lb..(max_x3_x4 div 3): x4;        % units of product X4 (since 3*x4 <= 200)

% Total cost (objective expression variable)
var int: total_cost;

% Constraints
% Total cost definition (objective handled separately)
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Raw material / capacity: combined production of X1 and X2 limited
constraint
  x1 + x2 <= max_x1_x2;

% Capacity coupling for X3 and X4: 2*X3 + 3*X4 within limit
constraint
  2 * x3 + 3 * x4 <= max_x3_x4;

% Strategic / demand mix requirement: X1 - 2*X2 + X3 at least threshold
constraint
  x1 - 2 * x2 + x3 >= min_mix;

% Difference constraint: X1 - (X2 + X3) not exceeding max_diff
constraint
  x1 - (x2 + x3) <= max_diff;

% Objective
solve minimize total_cost;