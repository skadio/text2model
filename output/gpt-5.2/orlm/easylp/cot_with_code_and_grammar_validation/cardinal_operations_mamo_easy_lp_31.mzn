% Parameters
float: costX = 0.5;
float: costY = 1.0;
int: maxTrips = 10000;
int: minTripsX = 3000;
int: minTripsY = 2000;

% Variables
var minTripsX..maxTrips: tripsX;
var minTripsY..maxTrips: tripsY;
var float: totalCost;

% Constraints
constraint tripsX + tripsY <= maxTrips;
constraint totalCost = costX * tripsX + costY * tripsY;

% Objective
solve minimize totalCost;