% Parameters
int: support_X = 50;        % Support points required per unit of X
int: support_Y = 75;        % Support points required per unit of Y

int: a1 = 2;                % Coefficient of X in mission success constraint
int: b1 = 1;                % Coefficient of Y in mission success constraint
int: rhs1 = 60;             % Minimum required combined strength

int: a2 = 1;                % Coefficient of X in logistics constraint
int: b2 = 3;                % Coefficient of Y in logistics constraint
int: rhs2 = 120;            % Maximum allowed combined load

% Variables
var 0..120: x;              % Number of units of X (integer, nonnegative)
var 0..40: y;               % Number of units of Y (integer, nonnegative)

var 0..(support_X*120 + support_Y*40): total_support; % Total support points (objective helper)

% Constraints
% Link total_support to the chosen numbers of units (linear expression)
constraint total_support = support_X * x + support_Y * y;

% Mission success constraint: combined strength must meet or exceed minimum
constraint a1 * x + b1 * y >= rhs1;

% Logistics constraint: combined load must not exceed maximum
constraint a2 * x + b2 * y <= rhs2;

% Objective
solve minimize total_support;

% (Optional) output for inspection
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_support = ", show(total_support), "\n"
];