% Parameters
int: costX = 5;              % Transportation cost per unit for center X
int: costY = 6;              % Transportation cost per unit for center Y
int: costZ = 3;              % Transportation cost per unit for center Z

int: capXY = 1000;           % Capacity limit for combined allocation of X and Y
int: capYZ = 1200;           % Capacity limit for combined allocation of Y and Z
int: minDiffXZ = 200;        % Minimum required difference between X and Z (X - Z >= 200)

int: lbX = 0; int: ubX = 700;  % Bounds for allocation at center X
int: lbY = 0; int: ubY = 500;  % Bounds for allocation at center Y
int: lbZ = 0; int: ubZ = 600;  % Bounds for allocation at center Z

% Variables
var lbX..ubX: allocX;        % Whole-number allocation to center X
var lbY..ubY: allocY;        % Whole-number allocation to center Y
var lbZ..ubZ: allocZ;        % Whole-number allocation to center Z

var int: total_cost;         % Total transportation cost (to be minimized)

% Constraints
% Total transportation cost definition
constraint
  total_cost = costX * allocX + costY * allocY + costZ * allocZ;

% Capacity constraint for combined allocation of centers X and Y
constraint
  allocX + allocY <= capXY;

% Capacity constraint for combined allocation of centers Y and Z
constraint
  allocY + allocZ <= capYZ;

% Minimum difference constraint between allocations at centers X and Z
constraint
  allocX - allocZ >= minDiffXZ;

% Objective
solve minimize total_cost;