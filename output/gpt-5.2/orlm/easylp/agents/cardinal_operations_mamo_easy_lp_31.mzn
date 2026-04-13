% Parameters
float: costX = 0.5;                 % Cost per trip for vehicle type X (dollars)
float: costY = 1.0;                 % Cost per trip for vehicle type Y (dollars)
int: maxTotalTrips = 10000;         % Maximum total trips allowed (X + Y)
int: minTripsX = 3000;              % Minimum required trips with type X
int: minTripsY = 2000;              % Minimum required trips with type Y

% Variables
var minTripsX..maxTotalTrips: tripsX;  % Integer number of trips made by type X
var minTripsY..maxTotalTrips: tripsY;  % Integer number of trips made by type Y

% Use explicit float bounds to avoid coercion issues with var float domains
float: maxCost = costX * int2float(maxTotalTrips) + costY * int2float(maxTotalTrips);

var 0.0..maxCost: totalCost;                 % Total cost in dollars (float)
var 0..ceil(maxCost): totalCostRounded;      % Total cost rounded to nearest dollar (int)

% Constraints
%--- Demand satisfaction: enforce minimum required trips for each vehicle type
constraint tripsX >= minTripsX;
constraint tripsY >= minTripsY;

%--- Operational limit: total trips across both vehicle types cannot exceed the maximum
constraint tripsX + tripsY <= maxTotalTrips;

%--- Cost calculation: total cost as a linear expression of trips
constraint totalCost = costX * int2float(tripsX) + costY * int2float(tripsY);

%--- Rounding to nearest dollar: totalCostRounded is the unique integer in [totalCost-0.5, totalCost+0.5)
constraint
  int2float(totalCostRounded) - 0.5 <= totalCost /\
  totalCost < int2float(totalCostRounded) + 0.5;

% Objective
solve minimize totalCostRounded;