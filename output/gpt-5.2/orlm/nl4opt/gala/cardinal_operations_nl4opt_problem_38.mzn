include "globals.mzn";

% Data (embedded)
int: chickens = 1200;

int: bus_cap = 100;
int: car_cap = 40;

int: bus_time_num = 2;     % 2 hours
int: bus_time_den = 1;

int: car_time_num = 3;     % 1.5 hours = 3/2
int: car_time_den = 2;

int: max_bus_trips = 10;
int: car_min_percent = 60;

% Decision variables
var 0..max_bus_trips: busTrips;
var 0..(chickens div car_cap + 50): carTrips;  % safe upper bound

% Constraints
constraint busTrips * bus_cap + carTrips * car_cap >= chickens;

% At least 60% of all trips are by car: carTrips / (busTrips + carTrips) >= 0.6
% Avoid division: 100*carTrips >= 60*(busTrips + carTrips)
constraint 100 * carTrips >= car_min_percent * (busTrips + carTrips);

% Objective: minimize total time (use integer scaling to avoid floats)
% total_hours = 2*busTrips + 1.5*carTrips
% Multiply by 2: total_time2 = 4*busTrips + 3*carTrips
var int: total_time2 = 4 * busTrips + 3 * carTrips;

solve minimize total_time2;

output [
  "Bus trips = ", show(busTrips), "\n",
  "Car trips = ", show(carTrips), "\n",
  "Total time (hours) = ", show(total_time2 div 2),
  if total_time2 mod 2 = 0 then "" else ".5" endif, "\n",
  "Total chickens capacity moved = ", show(busTrips * bus_cap + carTrips * car_cap), "\n"
];