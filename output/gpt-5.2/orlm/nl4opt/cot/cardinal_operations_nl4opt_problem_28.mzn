% Parameters (with values embedded)
int: DogCapability = 100;
int: TruckCapability = 300;
int: DogCost = 50;
int: TruckCost = 100;
int: MaxBudget = 1000;

% Upper bounds derived from budget (safe integer bounds)
int: maxDogTrips = MaxBudget div DogCost;      % 1000/50 = 20
int: maxTruckTrips = MaxBudget div TruckCost;  % 1000/100 = 10

% Variables
var 0..maxDogTrips: DogTrips;
var 0..maxTruckTrips: TruckTrips;
var 0..(DogCapability * maxDogTrips + TruckCapability * maxTruckTrips): TotalFish;

% Constraints
constraint DogCost * DogTrips + TruckCost * TruckTrips <= MaxBudget;
constraint DogTrips < TruckTrips;
constraint TotalFish = DogCapability * DogTrips + TruckCapability * TruckTrips;

% Objective
solve maximize TotalFish;