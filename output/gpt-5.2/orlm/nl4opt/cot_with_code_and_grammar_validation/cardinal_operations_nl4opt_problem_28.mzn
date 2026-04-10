% Parameters
int: DogCapability = 100;
int: TruckCapability = 300;
int: DogCost = 50;
int: TruckCost = 100;
int: MaxBudget = 1000;

int: maxDogTrips = MaxBudget div DogCost;
int: maxTruckTrips = MaxBudget div TruckCost;

% Variables
var 0..maxDogTrips: dogTrips;
var 0..maxTruckTrips: truckTrips;
var 0..(DogCapability * maxDogTrips + TruckCapability * maxTruckTrips): totalFish;

% Constraints
constraint DogCost * dogTrips + TruckCost * truckTrips <= MaxBudget;
constraint dogTrips < truckTrips;
constraint totalFish = DogCapability * dogTrips + TruckCapability * truckTrips;

% Objective
solve maximize totalFish;