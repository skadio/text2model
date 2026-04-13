% Parameters
float: costX = 0.5;
float: costY = 1.0;
int: maxTotalTrips = 10000;
int: minXTrips = 3000;
int: minYTrips = 2000;

% Variables
var minXTrips..maxTotalTrips: xTrips;
var minYTrips..maxTotalTrips: yTrips;
var 0.0..(costX * int2float(maxTotalTrips) + costY * int2float(maxTotalTrips)): totalCost;

% Constraints
constraint xTrips + yTrips <= maxTotalTrips;
constraint totalCost = costX * int2float(xTrips) + costY * int2float(yTrips);

% Objective
solve minimize totalCost;