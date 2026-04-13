% Parameters
% Maximum combined units allowed for X and Y
int: maxXY = 10;
% Maximum combined units allowed for Z and W
int: maxZW = 20;

% Minimum combined units required for X and Z
int: minXZ = 5;
% Minimum combined units required for Y and W
int: minYW = 7;

% Support points (cost) per unit (in dollars)
int: costX = 1000;
int: costY = 2000;
int: costZ = 500;
int: costW = 1500;

% Variables
% Number of units of each type to deploy (whole numbers, non-negative)
var 0..maxXY: x_units;
var 0..maxXY: y_units;
var 0..maxZW: z_units;
var 0..maxZW: w_units;

% Total support points (bounded using max possible given variable bounds)
var 0..(costX*maxXY + costY*maxXY + costZ*maxZW + costW*maxZW): total_support_points;

% Constraints
% Capacity limits for combined deployments
constraint x_units + y_units <= maxXY;   % X and Y together limited by logistics
constraint z_units + w_units <= maxZW;   % Z and W together limited by logistics

% Minimum strategic deployment requirements
constraint x_units + z_units >= minXZ;   % Ensure enough units among X and Z
constraint y_units + w_units >= minYW;   % Ensure enough units among Y and W

% Total support points definition (cost aggregation)
constraint total_support_points =
  costX * x_units +
  costY * y_units +
  costZ * z_units +
  costW * w_units;

% Objective
solve minimize total_support_points;