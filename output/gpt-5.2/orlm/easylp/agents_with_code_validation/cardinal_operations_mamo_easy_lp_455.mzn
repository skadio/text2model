% Parameters
% Unit costs (in dollars)
int: costX = 5000;
int: costY = 7000;

% Bounds on decision variables
int: minX = 0;
int: maxX = 5;
int: minY = 0;
int: maxY = 4;

% Contract / resource constraints
int: strengthX_coeff = 2;
int: strengthY_coeff = 3;
int: minStrength = 10;

int: maxTotalProjects = 8;

% Balance requirement: Y >= X + 1
int: minY_minus_X = 1;

% Variables
% Number of units allocated to project type X and Y (whole numbers)
var minX..maxX: x;
var minY..maxY: y;

% Total cost to minimize (in dollars)
var 0..(maxX*costX + maxY*costY): totalCost;

% Constraints
% --- Strength (contract fulfillment) constraint ---
% Combined strength from X and Y must meet or exceed the required minimum.
constraint
  strengthX_coeff * x + strengthY_coeff * y >= minStrength;

% --- Manpower / capacity constraint ---
% Total number of projects cannot exceed the available manpower limit.
constraint
  x + y <= maxTotalProjects;

% --- Balance requirement constraint ---
% Project Y must have at least one more unit than project X.
constraint
  y - x >= minY_minus_X;

% --- Total cost definition constraint ---
% Total cost is determined by unit costs and chosen quantities.
constraint
  totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;