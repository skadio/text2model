include "globals.mzn";

% Input parameters
int: N;
array[1..N] of bool: IsWorkstation;
array[1..N] of float: Price;
array[1..N] of float: DiskDrives;
array[1..N] of int: MemoryBoards;
int: MaxCpu;
int: MinDisk;
int: MaxDisk;
int: MinMemory;
int: MaxMemory;
array[1..N] of int: Demand;
int: DemandGP;
int: DemandWS;
array[1..N] of int: Preorder;
int: AltMemory;
array[1..N] of bool: AltCompatible;

% Decision variables
var float: profit;
array[1..N] of var 0.0..float(Demand[i]): Systems;
array[1..N] of var 0..MemoryBoards[i]: AltMemoryUsed;

% Objective
maximize profit;

% Constraints
constraint profit = sum(i in 1..N)(Price[i] * Systems[i]);

constraint sum(i in 1..N)(Systems[i]) <= MaxCpu;

constraint sum(i in 1..N)(DiskDrives[i] * Systems[i]) >= MinDisk;
constraint sum(i in 1..N)(DiskDrives[i] * Systems[i]) <= MaxDisk;

constraint sum(i in 1..N)((MemoryBoards[i] - AltMemoryUsed[i]) * Systems[i]) >= MinMemory;
constraint sum(i in 1..N)((MemoryBoards[i] - AltMemoryUsed[i]) * Systems[i]) <= MaxMemory;

constraint sum(i in 1..N where not IsWorkstation[i])(Systems[i]) <= DemandGP;
constraint sum(i in 1..N where IsWorkstation[i])(Systems[i]) <= DemandWS;

constraint forall(i in 1..N)(Systems[i] >= Preorder[i]);

constraint sum(i in 1..N where AltCompatible[i])(AltMemoryUsed[i]) <= AltMemory;

constraint forall(i in 1..N)(AltMemoryUsed[i] <= MemoryBoards[i] * Systems[i]);