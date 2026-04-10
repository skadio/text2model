% Parameters
int: costX = 150000;
int: costY = 200000;
int: maxProps = 10;
int: minDivers = 5;

% Variables
var 0..maxProps: X;
var 0..maxProps: Y;
var 0..(costX*maxProps + costY*maxProps): totalCost;

% Constraints
constraint X + Y <= maxProps;
constraint 2*X + Y >= 2*minDivers; % X + 0.5*Y >= 5
constraint totalCost = costX*X + costY*Y;

% Objective
solve minimize totalCost;