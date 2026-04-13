% Parameters
int: DogCapability = 100;
int: TruckCapability = 300;
int: DogCost = 50;
int: TruckCost = 100;
int: MaxBudget = 1000;

% Variables
var 0..(MaxBudget div DogCost): DogTrips;
var 0..(MaxBudget div TruckCost): TruckTrips;
var 0..(DogCapability*(MaxBudget div DogCost) + TruckCapability*(MaxBudget div TruckCost)): TotalFish;

% Constraints
constraint DogCost * DogTrips + TruckCost * TruckTrips <= MaxBudget;
constraint DogTrips < TruckTrips;
constraint TotalFish = DogCapability * DogTrips + TruckCapability * TruckTrips;

% Objective
solve maximize TotalFish;