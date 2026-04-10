% Parameters
int: costX = 50;                 % Cost per unit of product X ($)
int: costY = 75;                 % Cost per unit of product Y ($)
int: maxCombined = 1200;         % Capacity limit: X + Y <= 1200
int: minGap = 300;               % Minimum gap with more X: X - Y >= 300
int: maxStorage = 2000;          % Storage limit: 2*X + Y <= 2000

% Variables
var 0..maxCombined: unitsX;      % Units of product X (non-negative integer)
var 0..maxCombined: unitsY;      % Units of product Y (non-negative integer)
var 0..(costX*maxCombined + costY*maxCombined): totalCost; % Total production cost ($)

% Constraints

% Link totalCost to production quantities and unit costs
constraint
  totalCost = costX * unitsX + costY * unitsY;

% Capacity constraint: combined production cannot exceed maxCombined
constraint
  unitsX + unitsY <= maxCombined;

% Minimum gap constraint: produce at least minGap more units of X than Y
constraint
  unitsX - unitsY >= minGap;

% Storage constraint: twice X plus Y cannot exceed maxStorage
constraint
  2 * unitsX + unitsY <= maxStorage;

% Objective
solve minimize totalCost;