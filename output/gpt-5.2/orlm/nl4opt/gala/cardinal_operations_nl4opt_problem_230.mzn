include "globals.mzn";

% Data (embedded from problem statement)
int: containerCap = 30;
int: truckCap = 40;
int: minOil = 2000;
int: minContainers = 15;

% Decision variables
var 0..1000: containers;
var 0..1000: trucks;

% Constraints
constraint containers >= minContainers;
constraint containerCap * containers + truckCap * trucks >= minOil;

% Government restriction: trucks used <= half the containers used
% i.e., 2*trucks <= containers
constraint 2 * trucks <= containers;

% Objective: minimize total number of containers and trucks
solve minimize containers + trucks;

output [
  "containers = ", show(containers), "\n",
  "trucks = ", show(trucks), "\n",
  "total_units = ", show(containerCap * containers + truckCap * trucks), "\n",
  "total_vehicles = ", show(containers + trucks), "\n"
];