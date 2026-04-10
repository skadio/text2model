% Parameters
int: max_units = 100;                 % Maximum total number of units supported
int: min_strength = 50;               % Minimum required combined strength
int: z_y_diff_limit = 30;             % Maximum allowed difference between Z and Y

int: strength_per_x = 5;              % Strength contribution per unit of X in the requirement
int: strength_per_y = 3;              % Strength contribution per unit of Y in the requirement

int: support_x = 500;                 % Support points per unit of X
int: support_y = 600;                 % Support points per unit of Y
int: support_z = 700;                 % Support points per unit of Z

% Variables
var 0..max_units: x_units;            % Number of X units (integer, nonnegative)
var 0..max_units: y_units;            % Number of Y units (integer, nonnegative)
var 0..max_units: z_units;            % Number of Z units (integer, nonnegative)

var 0..(support_z * max_units): total_support; % Total support points (bounded)

% Constraints
% Total unit capacity (logistical limit)
constraint
  x_units + y_units + z_units <= max_units;

% Mission strength requirement from units X and Y
constraint
  strength_per_x * x_units + strength_per_y * y_units >= min_strength;

% Operational balance: Z and Y must not differ by more than the allowed limit
constraint
  abs(z_units - y_units) <= z_y_diff_limit;

% Link total_support to per-unit support point costs
constraint
  total_support = support_x * x_units + support_y * y_units + support_z * z_units;

% Objective
solve minimize total_support;

% (Optional) Output for inspection
output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "z_units=", show(z_units), "\n",
  "total_support=", show(total_support), "\n"
];