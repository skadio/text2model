% Parameters
float: costX = 0.5;
float: costY = 1.0;
int: maxTrips = 10000;
int: minX = 3000;
int: minY = 2000;

% Variables
var minX..maxTrips: xTrips;
var minY..maxTrips: yTrips;
var float: totalCost;

% Constraints
constraint xTrips + yTrips <= maxTrips;
constraint totalCost = costX * int2float(xTrips) + costY * int2float(yTrips);

% Objective
solve minimize totalCost;