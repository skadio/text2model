include "globals.mzn";

% Data (embedded)
int: minVisitors = 300;
int: capScooter = 2;
int: capRickshaw = 3;

% Decision variables
var 0..1000: scooters;
var 0..1000: rickshaws;

% Total visitors transported
constraint capScooter * scooters + capRickshaw * rickshaws >= minVisitors;

% At most 40% of vehicles can be rickshaws:
% rickshaws <= 0.4 * (scooters + rickshaws)
% => 5*rickshaws <= 2*(scooters + rickshaws) => 3*rickshaws <= 2*scooters
constraint 3 * rickshaws <= 2 * scooters;

% Objective: minimize total number of scooters
solve minimize scooters;

output [
  "Scooters = ", show(scooters), "\n",
  "Rickshaws = ", show(rickshaws), "\n",
  "Total vehicles = ", show(scooters + rickshaws), "\n",
  "Visitors transported = ", show(capScooter*scooters + capRickshaw*rickshaws), "\n"
];