% Parameters
int: costX = 1000;              % Cost per unit for Project X (air pollution)
int: costY = 500;               % Cost per unit for Project Y (water pollution)
int: costZ = 1200;              % Cost per unit for Project Z (land pollution)

int: totalUnitsMax = 100;       % Maximum total units across all projects

int: xMin = 0;  int: xMax = 50; % Bounds for units allocated to Project X
int: yMin = 0;  int: yMax = 40; % Bounds for units allocated to Project Y
int: zMin = 0;  int: zMax = 60; % Bounds for units allocated to Project Z

int: xAtLeastYPlus = 10;        % X must be at least this many units more than Y
int: zAtMostYPlus = 20;         % Z cannot exceed Y by more than this many units


% Variables
var xMin..xMax: unitsX;         % Integer units allocated to Project X
var yMin..yMax: unitsY;         % Integer units allocated to Project Y
var zMin..zMax: unitsZ;         % Integer units allocated to Project Z

% Total cost (upper bound derived from maximum allocations)
var 0..(costX*xMax + costY*yMax + costZ*zMax): totalCost;


% Constraints
% --- Total units budget constraint ---
constraint
  unitsX + unitsY + unitsZ <= totalUnitsMax;

% --- Balance constraint between Project X and Project Y ---
constraint
  unitsX >= unitsY + xAtLeastYPlus;

% --- Balance constraint between Project Z and Project Y ---
constraint
  unitsZ <= unitsY + zAtMostYPlus;

% --- Total cost definition constraint ---
constraint
  totalCost = costX * unitsX + costY * unitsY + costZ * unitsZ;


% Objective
solve minimize totalCost;