% Parameters
int: max_x1 = 150;                % Maximum capacity for unit type X1
int: max_x2 = 100;                % Maximum capacity for unit type X2
int: max_x3 = 80;                 % Maximum capacity for unit type X3
int: max_x4 = 20;                 % Maximum capacity for unit type X4

int: limit_x1_x2 = 200;           % Logistics limit: X1 + X2 <= 200

int: support_x1 = 10000;          % Support points per unit of X1
int: support_x2 = 5000;           % Support points per unit of X2
int: support_x3 = 8000;           % Support points per unit of X3
int: support_x4 = 6000;           % Support points per unit of X4

int: min_strength = 400;          % Constraint: 2*X1 + 3.5*X3 >= 400

int: max_diff_x2_halfx4 = 50;     % Constraint: |X2 - 0.5*X4| <= 50
int: max_x2_minus_x1_x3 = 70;     % Constraint: X2 - X1 - X3 <= 70


% Variables
var 0..max_x1: x1;                % Allocation for unit type X1 (integer)
var 0..max_x2: x2;                % Allocation for unit type X2 (integer)
var 0..max_x3: x3;                % Allocation for unit type X3 (integer)
var 0..max_x4: x4;                % Allocation for unit type X4 (integer)

var int: total_support_points;    % Total support points (objective, integer)


% Constraints
%--- Capacity/bounds are already enforced by variable domains (0..max_xi) ---

% Logistics constraint: combined supported units of X1 and X2 is limited
constraint
  x1 + x2 <= limit_x1_x2;

% Strategic strength constraint:
% Avoid fractional coefficient (3.5) by multiplying by 2:
% 2*(2*X1 + 3.5*X3) >= 2*400  =>  4*X1 + 7*X3 >= 800
constraint
  4 * x1 + 7 * x3 >= 2 * min_strength;

% Difference constraint: |X2 - 0.5*X4| <= 50
% Avoid fractions by multiplying by 2: |2*X2 - X4| <= 100
constraint
  abs(2 * x2 - x4) <= 2 * max_diff_x2_halfx4;

% Relative allocation constraint: X2 - X1 - X3 <= 70
constraint
  x2 - x1 - x3 <= max_x2_minus_x1_x3;

% Define total support points (kept integer, since coefficients are integers)
constraint
  total_support_points =
      support_x1 * x1
    + support_x2 * x2
    + support_x3 * x3
    + support_x4 * x4;


% Objective
solve minimize total_support_points;