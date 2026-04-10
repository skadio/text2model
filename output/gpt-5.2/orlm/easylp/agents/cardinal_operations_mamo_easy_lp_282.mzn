% Parameters
int: budgetMax = 5000;            % Total budget upper bound
int: minX = 1500;                 % Minimum allocation for sector X (advertising)
int: minY = 800;                  % Minimum allocation for sector Y (transportation)
int: minZ = 700;                  % Minimum allocation for sector Z (hospitality)

int: costX = 100;                 % Cost/return units per dollar invested in X
int: costY = 200;                 % Cost/return units per dollar invested in Y
int: costZ = 50;                  % Cost/return units per dollar invested in Z

% Variables
var minX..budgetMax: x;           % Dollars allocated to sector X (integer)
var minY..budgetMax: y;           % Dollars allocated to sector Y (integer)
var minZ..budgetMax: z;           % Dollars allocated to sector Z (integer)

var 0..(costX*budgetMax + costY*budgetMax + costZ*budgetMax): totalCost; % Total cost (units)

% Constraints
% Budget feasibility: total allocation cannot exceed the maximum budget
constraint
  x + y + z <= budgetMax;

% Total cost calculation: link totalCost to per-sector allocations and unit costs
constraint
  totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;