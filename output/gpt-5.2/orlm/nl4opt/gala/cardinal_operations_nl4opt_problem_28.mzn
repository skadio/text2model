% Fish transport optimization (LP as an integer linear model)
% Data embedded as requested

int: DogCapability = 100;
int: TruckCapability = 300;
int: DogCost = 50;
int: TruckCost = 100;
int: MaxBudget = 1000;

% Decision variables: number of trips (nonnegative integers)
var 0..MaxBudget div DogCost: dogTrips;
var 0..MaxBudget div TruckCost: truckTrips;

% Budget constraint
constraint DogCost * dogTrips + TruckCost * truckTrips <= MaxBudget;

% Dog trips must be less than truck trips
constraint dogTrips < truckTrips;

% Objective: maximize total fish transported
var int: totalFish = DogCapability * dogTrips + TruckCapability * truckTrips;

solve maximize totalFish;

output [
  "dogTrips = ", show(dogTrips), "\n",
  "truckTrips = ", show(truckTrips), "\n",
  "totalFish = ", show(totalFish), "\n",
  "totalCost = ", show(DogCost * dogTrips + TruckCost * truckTrips), "\n"
];