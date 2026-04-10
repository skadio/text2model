% Parameters
int: max_XY = 10;                 % Maximum total units of types X and Y
int: max_ZW = 20;                 % Maximum total units of types Z and W
int: min_XZ = 5;                  % Minimum total units among types X and Z
int: min_YW = 7;                  % Minimum total units among types Y and W

int: cost_X = 1000;               % Support points cost per unit of X
int: cost_Y = 2000;               % Support points cost per unit of Y
int: cost_Z = 500;                % Support points cost per unit of Z
int: cost_W = 1500;               % Support points cost per unit of W

% Variables
var 0..max_XY: X;                 % Number of X units (bounded by X+Y <= max_XY)
var 0..max_XY: Y;                 % Number of Y units (bounded by X+Y <= max_XY)
var 0..max_ZW: Z;                 % Number of Z units (bounded by Z+W <= max_ZW)
var 0..max_ZW: W;                 % Number of W units (bounded by Z+W <= max_ZW)

var 0..(max_XY*cost_X + max_XY*cost_Y + max_ZW*cost_Z + max_ZW*cost_W): total_support_points;
                                  % Total support points to minimize

% Constraints
% Capacity constraints: logistical limits on combined deployments
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

% Minimum deployment requirements for strategic objectives
constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

% Total support points definition (linking decision variables to total cost)
constraint total_support_points =
    cost_X * X + cost_Y * Y + cost_Z * Z + cost_W * W;

% Objective
solve minimize total_support_points;