% Parameters
int: DogCapability = 100;     % fish units transported per sled dog trip
int: TruckCapability = 300;   % fish units transported per truck trip
int: DogCost = 50;            % cost per sled dog trip
int: TruckCost = 100;         % cost per truck trip
int: MaxBudget = 1000;        % maximum total budget available

% Variables
var 0..(MaxBudget div DogCost): dogTrips;        % number of sled dog trips (non-negative integer)
var 0..(MaxBudget div TruckCost): truckTrips;    % number of truck trips (non-negative integer)
var 0..(DogCapability*(MaxBudget div DogCost) + TruckCapability*(MaxBudget div TruckCost)): totalFish;
% total fish transported (bounded using max possible trips under budget)

% Constraints

% Budget constraint: total transportation cost cannot exceed the maximum budget
constraint
  DogCost * dogTrips + TruckCost * truckTrips <= MaxBudget;

% Relationship constraint: sled dog trips must be strictly less than truck trips
constraint
  dogTrips < truckTrips;

% Total fish definition: totalFish equals fish carried by dog and truck trips
constraint
  totalFish = DogCapability * dogTrips + TruckCapability * truckTrips;

% Objective
solve maximize totalFish;