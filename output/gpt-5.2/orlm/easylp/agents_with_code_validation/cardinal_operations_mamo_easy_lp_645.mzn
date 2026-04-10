% Parameters
int: max_x1 = 150;              % Maximum capacity for unit type X1
int: max_x2 = 100;              % Maximum capacity for unit type X2
int: max_x3 = 80;               % Maximum capacity for unit type X3
int: max_x4 = 20;               % Maximum capacity for unit type X4

int: limit_x1_x2 = 200;         % Logistical limit on X1 + X2

int: req_strength = 400;        % Required minimum combined strength (2*X1 + 3.5*X3 >= 400)
int: max_diff_x2_x4 = 50;       % Limit on |X2 - 0.5*X4| <= 50
int: max_expr_x2_x1_x3 = 70;    % Limit on (X2 - X1 - X3) <= 70

int: cost_x1 = 10000;           % Support points per unit of X1
int: cost_x2 = 5000;            % Support points per unit of X2
int: cost_x3 = 8000;            % Support points per unit of X3
int: cost_x4 = 6000;            % Support points per unit of X4


% Variables
var 0..max_x1: x1;              % Allocated units of type X1
var 0..max_x2: x2;              % Allocated units of type X2
var 0..max_x3: x3;              % Allocated units of type X3
var 0..max_x4: x4;              % Allocated units of type X4

% Upper bound is the maximum possible total cost given max capacities
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_support;


% Constraints
% Logistical limit: combined units of X1 and X2
constraint x1 + x2 <= limit_x1_x2;

% Strategic strength requirement:
% 2*x1 + 3.5*x3 >= req_strength  <=>  4*x1 + 7*x3 >= 2*req_strength
constraint 4 * x1 + 7 * x3 >= 2 * req_strength;

% Difference limit between X2 and half of X4:
% |x2 - 0.5*x4| <= max_diff_x2_x4  <=>  |2*x2 - x4| <= 2*max_diff_x2_x4
constraint abs(2 * x2 - x4) <= 2 * max_diff_x2_x4;

% Expression limit: (x2 - x1 - x3) <= max_expr_x2_x1_x3
constraint x2 - x1 - x3 <= max_expr_x2_x1_x3;

% Define total support points from unit allocations and costs
constraint total_support =
  cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_support;