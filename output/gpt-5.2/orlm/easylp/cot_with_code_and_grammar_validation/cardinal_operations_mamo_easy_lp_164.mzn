% Parameters
int: costX = 150000;   % commercial building
int: costY = 200000;   % residential complex
int: maxProps = 10;
int: minDivers = 5;

% Variables
var 0..maxProps: X;    % number of commercial buildings
var 0..maxProps: Y;    % number of residential complexes
var 0..(maxProps * max(costX, costY)): totalCost;

% Constraints
constraint X + Y <= maxProps;
constraint 2 * X + Y >= 2 * minDivers;  % X + 0.5*Y >= 5  <=>  2X + Y >= 10
constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;