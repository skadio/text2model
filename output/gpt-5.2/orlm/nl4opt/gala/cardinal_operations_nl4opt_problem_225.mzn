include "globals.mzn";

% Data (embedded)
int: monkeys = 300;

int: busCap = 20;
int: busTime = 30;   % minutes per bus trip
int: carCap = 6;
int: carTime = 15;   % minutes per car trip

int: maxBusTrips = 10;
int: carPercent = 60; % at least 60% of trips are by car

% Decision variables
var 0..maxBusTrips: busTrips;
var 0..1000: carTrips;  % safe upper bound

% Total time (objective)
var 0..100000: totalTime = busTime * busTrips + carTime * carTrips;

% Constraints
constraint busCap * busTrips + carCap * carTrips >= monkeys;
constraint busTrips <= maxBusTrips;

% At least 60% of trips should be by car:
% carTrips / (busTrips + carTrips) >= 0.60  <=>  100*carTrips >= 60*(busTrips+carTrips)
constraint 100 * carTrips >= carPercent * (busTrips + carTrips);

solve minimize totalTime;

output [
  "Bus trips = ", show(busTrips), "\n",
  "Car trips = ", show(carTrips), "\n",
  "Total trips = ", show(busTrips + carTrips), "\n",
  "Capacity moved = ", show(busCap*busTrips + carCap*carTrips), "\n",
  "Total time (min) = ", show(totalTime), "\n"
];