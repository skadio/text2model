% Parameters (with values embedded)
int: costX = 20;
int: costY = 30;
int: reqEffortCoeffX = 5;
int: reqEffortCoeffY = 10;
int: reqEffortMin = 50;
int: qualCoeffX = 3;
int: qualCoeffY = 4;
int: qualMax = 36;

% Upper bounds derived from quality constraint: 3x + 4y <= 36
int: maxX = qualMax div qualCoeffX; % floor(36/3)=12
int: maxY = qualMax div qualCoeffY; % floor(36/4)=9

% Variables
var 0..maxX: x; % resources for Task X (integer, nonnegative)
var 0..maxY: y; % resources for Task Y (integer, nonnegative)
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint reqEffortCoeffX * x + reqEffortCoeffY * y >= reqEffortMin;
constraint qualCoeffX * x + qualCoeffY * y <= qualMax;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;