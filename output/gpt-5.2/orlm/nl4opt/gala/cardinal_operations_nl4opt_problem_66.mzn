include "globals.mzn";

% Data (embedded from the problem statement)
int: tractorCap = 40;
int: carCap     = 20;
int: demand     = 500;

% Decision variables
var 0..ceil(demand div tractorCap) + 20: tractors;  % safe upper bound
var 0..ceil(demand div carCap) + 20: cars;          % safe upper bound

% Constraints
constraint tractorCap * tractors + carCap * cars >= demand;
constraint cars >= 2 * tractors;

% Objective: minimize total number of vehicles
solve minimize tractors + cars;

output [
  "tractors = ", show(tractors), "\n",
  "cars = ", show(cars), "\n",
  "total = ", show(tractors + cars), "\n",
  "carried_kg = ", show(tractorCap * tractors + carCap * cars), "\n"
];