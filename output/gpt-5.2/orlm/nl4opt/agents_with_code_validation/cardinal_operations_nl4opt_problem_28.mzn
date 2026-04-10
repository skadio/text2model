% Parameters
% Capacity (fish per trip)
int: DogCapability = 100;
int: TruckCapability = 300;

% Cost per trip
int: DogCost = 50;
int: TruckCost = 100;

% Maximum available budget
int: MaxBudget = 1000;

% Variables
% Number of trips (non-negative integers), each bounded by what budget alone would allow
var 0..MaxBudget div DogCost: dog_trips;
var 0..MaxBudget div TruckCost: truck_trips;

% Total fish transported (bounded by the maximum possible under individual budget bounds)
var 0..(DogCapability * (MaxBudget div DogCost) + TruckCapability * (MaxBudget div TruckCost)): total_fish;

% Constraints
% Link total_fish to the number of trips and per-trip capacities
constraint
  total_fish = DogCapability * dog_trips + TruckCapability * truck_trips;

% Respect the maximum budget (total trip costs cannot exceed MaxBudget)
constraint
  DogCost * dog_trips + TruckCost * truck_trips <= MaxBudget;

% Operational rule: sled dog trips must be less than truck trips
constraint
  dog_trips < truck_trips;

% Objective
solve maximize total_fish;