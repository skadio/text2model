% Parameters (with values embedded)
int: nMethods = 3;
set of int: METHODS = 1..nMethods;

int: MOTORCYCLE = 1;
int: SMALL_TRUCK = 2;
int: LARGE_TRUCK = 3;

array[METHODS] of int: pollution = [40, 70, 100];
array[METHODS] of int: capacity  = [10, 20, 50];

int: maxMotorcycleTrips = 8;
int: minTotalCapacity = 300;
int: maxTotalTrips = 20;
int: methodsToUse = 2;

% Variables
array[METHODS] of var 0..maxTotalTrips: trips;
array[METHODS] of var bool: used;

var 0..(maxTotalTrips * 100): total_pollution;

% Constraints
constraint forall(m in METHODS) (trips[m] <= maxTotalTrips * bool2int(used[m]));
constraint sum(m in METHODS)(bool2int(used[m])) = methodsToUse;

constraint trips[MOTORCYCLE] <= maxMotorcycleTrips;

constraint sum(m in METHODS)(trips[m]) <= maxTotalTrips;
constraint sum(m in METHODS)(capacity[m] * trips[m]) >= minTotalCapacity;

constraint total_pollution = sum(m in METHODS)(pollution[m] * trips[m]);

% Objective
solve minimize total_pollution;